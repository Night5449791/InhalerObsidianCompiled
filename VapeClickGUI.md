# Vape Click GUI — Component API Reference

> The hand-rolled click GUI that ships with the **Vape build** (`InhalerCompiled`). This is the *other* UI layer: the Obsidian build in this repo replaces it entirely (see `ObsidianUI.md`). Read this file when you are porting a Vape component **into** the Obsidian adapter, or when you need to know what a game module actually calls.
>
> Sources: `InhalerV4ForRoblox/src/guis/new/` — `base.lua` (7272 lines total across the folder), `init.lua`, `components/*` (26 files), `libraries/*` (5 files).

---

## Table of Contents

1. [How the GUI is assembled](#1-how-the-gui-is-assembled)
2. [`vape` — the root object](#2-vape--the-root-object)
3. [The component system](#3-the-component-system)
4. [Containers](#4-containers)
5. [Options — `<Module>:CreateXxx({...})`](#5-options--modulecreatexxx)
6. [Save format — the wire format](#6-save-format--the-wire-format)
7. [GUI libraries](#7-gui-libraries)
8. [Ported-to-Obsidian mapping](#8-ported-to-obsidian-mapping)
9. [Pitfalls](#9-pitfalls)

---

## 1. How the GUI is assembled

`base.lua` is **not self-contained**. The bundler (`processUI.js`) inlines files at three markers:

| Marker | `base.lua` line | Replaced with |
|---|---|---|
| `--Libraries` | 67 | every file in `libraries/`, sorted **ascending** by name, then a `vape.Libraries = {…}` table |
| `--Components` | 772 | every file in `components/` wrapped as `components.<Name> = function(props, children, api) … end`, sorted **ascending** |
| `--Init` | 574 | the whole of `init.lua`, each file in `overlays/` first wrapped in `run(function() … end)` at its own `--Overlays` marker, sorted **descending**, then the entire body indented one tab |

The output is one flat chunk, `guis/new.lua`, which ends with `return vape`.

```
guis/new/
├── base.lua          # vape table + every vape:* method; has the 3 markers
├── init.lua          # vape:LoadGUI() body: ScreenGui, categories, panes, overlays
├── libraries/        # color, getfontbounds, getvapeasset, tween, uipallet  → globals
├── components/       # 26 files → components.<Name> functions
├── overlays/         # TargetInfo, TextGUI → run(function() … end) inside --Init
└── assets/           # png icons, fetched through getvapeasset
```

`init.lua` builds, in order: the `ScreenGui` (`gui`), `ScaledGui` (the scaled container), `ClickGui`, the scarcity banner, the modal, `components.GUI({})`, then one `vape:CreateCategory(...)` per category, the Friends/Targets/Profiles `CategoryList`s, `LegitWindow`, `SearchBar`, `OverlayBar`, and the General/Modules/GUI/Notifications `SettingsPane`s.

---

## 2. `vape` — the root object

### 2.1 Fields (`base.lua:1-22`)

| Field | Meaning |
|---|---|
| `ActiveBinds` | keybinds currently held |
| `Categories` | every `Category` / `CategoryList` by name |
| `GUIColor` | accent colour |
| `HeldKeybinds` | keys down this frame |
| `Loaded` | three-state sentinel: `false` → `canSave` → `nil` after `Uninject` |
| `Libraries` | UI libraries as a table (`--Libraries` emits it) |
| `Modules` | every module by name |
| `Place` | `game.PlaceId`, overwritten by a redirect |
| `Profile` | active save profile, default `'default'` |
| `RainbowSliders` | sliders currently in rainbow mode |
| `Settings` | the GUI settings panes |
| `SettingToggleNotifications` | notify on option toggle |
| `ThreadFix` | `setthreadidentity and true` |
| `ToggleNotifications` | notify on module toggle |
| `Version` | `'4.22'` |
| `Windows` | open windows (legit window, etc.) |

### 2.2 Methods (`base.lua`)

| Method | Line | Contract |
|---|---|---|
| `vape:BlurCheck()` | 331 | Is the game's own UI capturing input — used by `canClick` |
| `vape:CreateCategory(props)` | 338 | Build a `Category` (a sidebar column of modules) |
| `vape:CreateCategoryList(props)` | 342 | Build a `CategoryList` (Friends / Targets / Profiles) |
| `vape:CreateNotification(title, text, duration, type)` | 346 | Toast; `type` ∈ `'info' \| 'warning' \| 'alert'` |
| `vape:CreateOverlay(props)` | 444 | Floating draggable panel |
| `vape:Load(skipgui, profile)` | 448 | Read the profile from disk and apply every option |
| `vape:LoadOptions(obj, data)` | 563 | Per-object half of `Load` |
| `vape:LoadGUI()` | 573 | **Empty in source** — filled by `--Init` |
| `vape:Remove(obj)` | 577 | Destroy by name: `Modules` → `Legit.Modules` → `Categories` |
| `vape:Save(newProfile)` | 608 | Write both profile JSON files |
| `vape:SaveOptions(obj)` | 642 | Per-object half of `Save` |
| `vape:SortCategories()` | 655 | Re-sort module cards after a toggle |
| `vape:Uninject()` | 675 | Full teardown; sets `Loaded = nil` |
| `vape:UpdateGUI()` | 721 | Deferred repaint |
| `vape:UpdateGUIQueue(hue, sat, val)` | 735 | Queue a colour repaint |

Also `vape:Clean(x)` (`addMaid`, `:166`) — accepts a connection, an `Instance`, a thread or a function.

### 2.3 `vape.Loaded` is a three-state sentinel

`false` → set to `canSave` at the end of `Load` (`base.lua:537`) → `nil` in `Uninject` (`base.lua:675`).

Modules rely on it: `repeat … until vape.Loaded == nil` to exit a loop, `repeat task.wait() until vape.Loaded` to wait for the GUI.

---

## 3. The component system

### 3.1 Shape

Every file in `components/` becomes:

```lua
components.Toggle = function(props, children, api)
	-- builds Instances, returns `component`
end
```

`vape.Components` (`base.lua:774`) is a **metatable over `components`**. Writing `components.X = fn` retro-installs `CreateX` on every existing module — so a component authored later still becomes available on modules created earlier:

```lua
vape.Components = setmetatable(components, {
	__newindex = function(_, index, callback)
		for _, module in vape.Modules do
			rawset(module, 'Create'..index, function(_, props)
				return callback(props, module.Children, module)
			end)
		end
		-- same for vape.Legit.Modules
	end
})
```

**Consequence**: a component only exists on objects created *after* it, unless the metatable has already fired. Author new components in `components/` (they are all bundled before `--Init` runs) rather than defining one inline.

### 3.2 What a component receives

| Argument | Meaning |
|---|---|
| `props` | the option table the caller passed, plus `<Module>`'s own bookkeeping |
| `children` | the `Module.Children` frame — where the option's row is parented |
| `api` | the owning module *or* container (used for `api.Legit` checks, target lists) |

### 3.3 What a component must answer

Not every component defines all of these; the ones that do are what `vape:Save`/`Load` and the modules call:

| Method | Used by | Meaning |
|---|---|---|
| `component:Load(data)` | `vape:LoadOptions` | Apply saved state |
| `component:Save(data)` | `vape:SaveOptions` | Write state under `data[props.Name]` |
| `component:SetValue(...)` | modules | programmatic change |
| `component:Toggle()` | modules | open/close an expandable option |
| `component:Color(h, s, v, rainbow)` | `vape:UpdateGUIQueue` | theme repaint |
| `component:Change(...)` | modules | replace a list (dropdown) |
| `component:Destroy()` | `vape:Remove` | teardown |

Options are stored in `module.Options[Name]`, which is how a module reaches them later: `module.Options.Mode.Value`.

---

## 4. Containers

Every container ends with a loop installing `Create<Name>` onto itself, so options can be added to it directly.

| Container | File | Notes |
|---|---|---|
| `Category` | `components/Category.lua` | one sidebar column; `.Object` 220 wide, expands to `math.min(41 + AbsoluteContentSize.Y / scale.Scale, 601)` |
| `CategoryList` | `components/CategoryList.lua` | Friends / Targets / Profiles; holds `List`, `ListEnabled`, `GetValue`, `ChangeValue` |
| `GUI` | `components/GUI.lua` | the main click-gui frame |
| `Module` | `components/Module.lua` | a module card, 220×40; `.Object`, `.Children`, `.Edit`, `.Bind`, `.Connections` |
| `LegitModule` | `components/LegitModule.lua` | legit-mode card; options go in `Module.Children`, accepts `Size` |
| `LegitWindow` | `components/LegitWindow.lua` | container for legit modules; `:CreateModule(props)` |
| `Overlay` | `components/Overlay.lua` | floating panel; `.Button`, `.Pin`, `.Expand`, `.Update` |
| `OverlayBar` | `components/OverlayBar.lua` | the bar listing overlays |
| `SettingsPane` | `components/SettingsPane.lua` | the General / Modules / GUI / Notifications panes |

`Module` line 1 calls `vape:Remove(props.Name)`, so re-running a chunk hot-reloads that module.

---

## 5. Options — `<Module>:CreateXxx({...})`

Extracted from the `props.X` each component actually reads. Anything not listed here is ignored by that component.

### `CreateToggle`

```lua
local T = Module:CreateToggle({
	Name = 'Enable',
	Default = false,
	Tooltip = 'Hover text',
	Function = function(enabled) end,
	Darker = false,
	Visible = true,
})
```

Fields: `Name`, `Default`, `Tooltip`, `Function`, `Darker`, `Visible`. Saves `{Enabled}`.
Reads/writes `.Enabled`.

### `CreateSlider`

```lua
local S = Module:CreateSlider({
	Name = 'Speed',
	Min = 0, Max = 100, Decimal = 10, Default = 16,
	Suffix = function(val) return 'studs' end,
	Function = function(val, wasReleased) end,
})
```

Fields: `Name`, `Min`, `Max`, `Decimal`, `Default`, `Suffix`, `Tooltip`, `Function(val, final)`, `Darker`, `Visible`. Saves `{Value, Max}`. Methods: `:SetValue(value, position, wasReleased)`.

### `CreateTwoSlider`

Fields: `Name`, `Min`, `Max`, `Decimal`, `DefaultMin`, `DefaultMax`, `Tooltip`, `Function`, `Darker`, `Visible`.
Saves `{ValueMin, ValueMax}`. **`:SetValue` never calls `props.Function`** — see §9.

### `CreateDropdown`

```lua
local D = Module:CreateDropdown({
	Name = 'Mode',
	List = {'All', 'Individual'},
	Function = function(value, isClick) end,
})
```

Fields: `Name`, `List`, `Function(value, isClick)`, `Tooltip`, `Darker`, `Visible`. Saves `{Value}`.
Methods: `:SetValue(value, isClick)`, **`:Change(list)`** (swaps the whole list).
`SetValue` falls back to `List[1]` when the value is missing — see §9.

### `CreateTextBox`

Fields: `Name`, `Default`, `Placeholder`, `Player`, `Function`, `Tooltip`, `Darker`, `Visible`.
Saves `{Value}`. `Function(enter)` — receives a boolean, not the text.

### `CreateTextList`

Fields: `Name`, `Default`, `Placeholder`, `Player`, `Color`, `TextFunction`, `Function`, `Tooltip`, `Darker`, `Visible`.
Saves `{List, ListEnabled}`. Public state: `.List`, `.ListEnabled`.
**`:ChangeValue(value)` is a toggle** — adds if absent, removes if present — and then calls `props.Function(List)`.

### `CreateColorSlider`

Fields: `Name`, `DefaultHue`, `DefaultSat`, `DefaultValue`, `DefaultOpacity`, `Tooltip`, `Function`, `Darker`, `Visible`.
Saves `{Hue, Sat, Value, Opacity, Rainbow}`. Methods: `:SetValue(h, s, v, o)`, `:Toggle()`.

### `CreateBind`

Fields: `Name`, `Default`, `Hold`, `Cover`, `Module`, `NoRemove`, `Tooltip`, `Darker`, `Visible`.
Saves under `props.Name` (the module bind uses the literal key `"Bind"`) `{Keys, Mobile = {X, Y}, Hold}`.
Methods: `:SetBind(keys, mouse)`, `:CreateMobileButton(position)`, `:DestroyMobileButton()`.

### `CreateButton`

Fields: `Name`, `Function`, `Tooltip`, `Darker`. Saves nothing.

### `CreateDivider`

Field: `Text`. Saves nothing. Returns nothing.

### `CreateFont`

Fields: `Name`, `Default`, `Function`, `Darker`, `Visible`. Builds a dropdown of `Default` + `'Custom'` + every `Enum.Font` name, plus an asset-id box for the custom entry.

### `CreateTargets`

```lua
local T = Module:CreateTargets({Players = true, NPCs = false, Walls = true})
```

Fields: `Players`, `NPCs`, `Walls`, `Invisible`, `Function`, `Tooltip`, `Darker`, `Visible`.
**Always saves under the hardcoded key `"Targets"`**, ignoring `Name` — one targets object per module survives a save.

### `CreateImageToggle`

Fields: `Name`, `Icon`, `Position`, `Size`, `Default`, `Function`, `Darker`, `Visible`.

---

## 6. Save format — the wire format

`vape:Save` writes two JSON blobs (`v = 1`):

| File | Shape |
|---|---|
| `newvape/profiles/<game.GameId>.gui.txt` | `{Categories, Profile, v}` — layout of non-overlay categories |
| `newvape/profiles/<Profile><Place>.txt` | `{Modules, Categories, Legit, v}` — module state + overlay categories |

A module entry:

```lua
data[props.Name] = {
	Enabled = self.Enabled,
	Options = vape:SaveOptions(self),
	Visible = self.Visible,
}
```

An option entry is `data[props.Name] = {...}` using the shapes in §5.

**This is a wire format.** Older profiles read it back; changing a key silently resets that setting for every existing user. `v ~= 1` drops `guiData.Categories.Main` and migrates legacy single-key binds. Corrupt JSON degrades to `{Categories = {}}`, raises an `alert` notification and sets `canSave = false`.

Other profile files: `commit.txt`, `asset.txt`, `gui.txt`, `whitelist.json`, `cheaters.json`, `color.txt` (theme override read by `uipallet`).

---

## 7. GUI libraries

Bundled as globals by `--Libraries` (`base.lua:67`), available to every component and overlay:

| Library | Purpose |
|---|---|
| `color` | `vape.Color(c)` / `vape.TextColor(c)` — lighten / darken against the palette |
| `getfontbounds` | `getfontbounds(text, size, font)` → `Vector2` via `TextService:GetTextBoundsAsync` |
| `getvapeasset` | downloads a png by path, with an inline `rbxassetid://` fallback; returns `''` on a miss |
| `tween` | `tween:Tween(obj, info, goal)` — a `TweenService:Create` wrapper |
| `uipallet` | the palette: `Main`, `Text`, `Font`, `FontSemiBold`, `Tween` |

`uipallet` is the accent/font source. The Vape build sets `Font = Font.fromEnum(Enum.Font.Arimo)`; **the Obsidian build must not copy that** — Obsidian owns its own typography (`AGENTS.md` §6).

---

## 8. Ported-to-Obsidian mapping

What each Vape container/option becomes in the Obsidian build. The full contract (including the frozen `vape` surface) is `AGENTS.md` §4.

| Vape | Obsidian |
|---|---|
| `createCategory(name)` → sidebar column | `Window:AddTab(name, icon)` |
| sub-panes inside a category | `Tab:AddGroupbox({Side = "Left" \| "Right", Name = …})` |
| `CreateModule({Name, Function})` | `Groupbox:AddToggle(id, {Text = Name, Callback = Function})` + `AddSettings` for its options |
| `CreateToggle` | `AddToggle` — `.Enabled` ↔ `.Value` |
| `CreateSlider` | `AddSlider` — `.Value`, `.Max` |
| `CreateTwoSlider` | **no equivalent** — two `AddSlider`s or an `AddInput` pair, still saving `{ValueMin, ValueMax}` |
| `CreateDropdown` | `AddDropdown` — `.Change(list)` → `Dropdown:SetValues` |
| `CreateTextBox` | `AddInput` |
| `CreateTextList` | `AddInput` + `AddDropdown(Multi)` |
| `CreateColorSlider` | `AddColorPicker` — keep `Rainbow` in the save shape |
| `CreateBind` | `AddKeyPicker` — module bind keeps key `"Bind"` |
| `CreateButton` / `CreateDivider` | `AddButton` / `AddDivider` — save nothing |
| `CreateImageToggle` | `AddToggle` (no image toggle in Obsidian) |
| `CreateTargets` | toggle trio in a dependency box, still keyed `"Targets"` |
| `vape:CreateNotification` | `Library:Notify({Title, Description, Time, Icon})` |
| `vape:CreateOverlay` | `Library:AddDraggableMenu` |
| `createCategoryList` (Friends/Targets/Profiles) | `AddDropdown({Multi = true, SpecialType = "Player"})` |
| `vape:UpdateGUIQueue` | `Library:UpdateColorsUsingRegistry()` / `AddToRegistry` |
| `vape:Uninject` | `Library:Unload()` **plus** `vape.Loaded = nil` yourself |

Convert save shapes **inside** `CreateXxx`, never in the profile code (`AGENTS.md` §4.4).

---

## 9. Pitfalls

These are real behaviours of this code, not preferences. Confirm each against the source before relying on it.

- **`vape:Remove` only sees live objects.** A product base runs before its own category files, so it can only drop universal's modules at that point.
- **`CreateTargets` ignores `Name`.** It always writes under the literal `"Targets"` key (`components/Targets.lua:137`), so a second targets object in the same module overwrites the first on save.
- **`TwoSlider:SetValue` never fires `props.Function`** (`components/TwoSlider.lua:128` writes state and tweens only). A module that only reacts through `Function` will miss programmatic changes.
- **`Dropdown:SetValue` silently falls back to `List[1]`** when the value is absent. A renamed or stale value becomes the first entry with no warning.
- **`ChangeTarget`'s `Visible` is never saved.** A sub-option under an already-enabled parent has to be re-applied when the parent is enabled.
- **`Enabled and nil or true` is always `true`.** Pass booleans through unchanged.
- **Two scopes per product.** `base.lua` shares one with unwrapped files (any file whose text contains `run(`); a duplicated top-level local silently overwrites the other's. Wrapped files are isolated.
- **`base.lua:560`** — `vape:Load` ends with `return toggleData`, but `toggleData` is never defined.
- **Font**: `uipallet` sets `Arimo` for this build. Do not carry `Enum.Font.Arimo`/`Arial`/`Font.fromEnum` into the Obsidian port — Obsidian's theme owns the font (`AGENTS.md` §6).
- **`SetIconModule` timing (Obsidian side)**: must run before any UI is created. There is no Vape equivalent; the Vape build loads png assets through `getvapeasset` instead.

---

*Derived from `InhalerV4ForRoblox/src/guis/new/` at the time of writing. Line numbers drift — re-check before trusting one.*
