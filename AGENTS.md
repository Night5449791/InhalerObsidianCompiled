# AGENTS.md

Guidance for any AI agent (Claude, Codex, Gemini, Copilot, Cursor, …) working in **`InhalerObsidianCompiled`**. This repository is a **build output**, not a source tree: nothing here is written by hand, and nothing here should be edited by hand. It is produced from `InhalerV4ForRoblox/src/` by a bundler you have to reconstruct (`§8`).

`InhalerV4ForRoblox/AGENTS.md` and `InhalerV4ForRoblox/CODEBUDDY.md` stay authoritative for the *source*. This file only covers how that source becomes the Obsidian build.

Section numbers are shared with `CODEBUDDY-OBSIDIAN.md` — keep them stable.

**Read `ObsidianUI.md` before writing any Obsidian UI code.** It is the complete, unabridged Obsidian API reference (2035 lines: window, tabs, groupboxes, tabboxes, dependency boxes, every element, library core, loading screen, notifications, dialogs, overlays, keybind menu, icons, ThemeManager, SaveManager, options registry, deprecated APIs, gotchas, quick-start template) and it sits next to this file in the repo root. `Appendix A` below is a condensed copy of it — good enough to recognise an API, **not** good enough to author against. Whenever you are about to write or change a `Library:` / `Window:` / `Tab:` / `Groupbox:` / element call, confirm the exact signature, defaults and argument order in `ObsidianUI.md` first; guessing an argument order is the most common way an Obsidian port breaks at runtime with no useful error.

## 0. What this repo is

`Night5449791/InhalerObsidianCompiled` — the **Obsidian-UI build of Inhaler V4**. Same game modules, same whitelist, same backend; the entire GUI is re-implemented on top of [Obsidian](https://github.com/deividcomsono/Obsidian) instead of Vape's own widget library.

| | Vape build | **this build** |
|---|---|---|
| repo | `InhalerCompiled` | `InhalerObsidianCompiled` |
| GUI | `guis/new/` → hand-rolled Instances | **Obsidian** (`Library:CreateWindow`, tabs, groupboxes) |
| UI library | Vape's `components/*` | **Obsidian** + its `ThemeManager`/`SaveManager` addons |
| game modules | unchanged | **unchanged** |
| libraries | unchanged | **partly rewritten** (`§6`) |
| build | CI on push to `main` | **local only**, compiled by hand and then pushed (`§8.6`) |

The fork is CC BY 4.0; upstream Vape is CC0 1.0; Obsidian is by deivid (see `ObsidianUI.md` §1).

Rules for agents:

- **Never hand-edit a file in this repo.** It is rebuilt from `src/` and any edit is lost on the next build.
- **The source tree is read-only during a build.** `InhalerV4ForRoblox/` is only *read* — `git status` there must be clean before and after, with nothing staged, committed or pushed. A build never has a reason to touch it: if the output looks wrong, fix the bundler or this port, not the source. Changing the source is a separate, deliberate task the user has to ask for (`§8.0`).
- Read a file before reasoning about it. Never assume a module exists — check the build output.
- Change only what was asked. No drive-by refactors.
- Match Vape's style in anything that survives into the output: **tabs, no semicolons, no collapsed multi-argument calls**, localize aggressively (`InhalerV4ForRoblox/AGENTS.md` §10).
- Obsidian's own upstream style is **spaces**, but any file you author here follows **Vape's tabs** — the two must not mix inside one file.

## 1. Commands

This repo has **no** CI, no `package.json`, no lint, no test suite. The only build is the one you write (`§8`) and run locally:

```bash
cd ../InhalerBundlerObsidian
bash scripts/fetch-obsidian.sh     # once: vendor/Obsidian/Library.lua + addons
node index.js prod                 # writes ../InhalerObsidianCompiled
```

The only syntax check available, per file — rewrite the Luau-only spellings first, then parse with Lua 5.4:

```bash
sed -E -e 's/[[:space:]]+continue([[:space:]]|$)/ break\1/g' \
       -e 's/([A-Za-z_][A-Za-z0-9_.]*) ([+-])= /\1 = \1 \2 /g' \
       -e 's/([A-Za-z_][A-Za-z0-9_.]*) \*= /\1 = \1 * /g' \
       -e 's|//|/|g' FILE.lua > /tmp/check.lua \
  && luac -p /tmp/check.lua && echo "syntax OK"
```

`//`, `*=` and `continue` are Luau-only and Lua 5.4 rejects them; the three `-e` rules above are the minimum rewrite. A file that still fails after that is using a Luau *expression* form (`if … then … else`, string interpolation, type annotations) — that is normal in this codebase and **not** a syntax error you introduced.

Testing needs a Roblox executor. Mirror the output into its workspace so paths match runtime `newvape/...`:

```lua
shared.VapeDeveloper = true
loadstring(game:HttpGet('https://raw.githubusercontent.com/Night5449791/InhalerObsidianCompiled/main/loader.lua', true))()
```

## 2. Boot chain — identical to the Vape build

The three-file chain is **not** changed by the Obsidian port. Keep it byte-for-byte except for the repository name in the CDN url.

1. Root `loadstring` fetches `loader.lua`.
2. `loader.lua` bootstraps the filesystem: executor fallbacks (`isfile`, `delfile`), `downloadFile(path)` caching from `raw.githubusercontent.com/Night5449791/InhalerObsidianCompiled/<commit>/<path>`, folder creation, commit sha scraped from `currentOid` into `newvape/profiles/commit.txt`, then `loadstring(downloadFile('newvape/main.lua'), 'main')()`.
3. `main.lua` waits for `game:IsLoaded()`, calls `shared.vape:Uninject()` on reload, loads `newvape/guis/new.lua` into `shared.vape` (GUI name is still the literal `'new'`), then `newvape/games/universal.lua`, then `newvape/games/<PlaceId>.lua` if present, then `finishLoading()`.

**Every downloaded `.lua` must carry the watermark line**

```
--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.
```

`wipeFolder()` deletes only files that still carry it (and never `loader`). Drop it and the cache never invalidates; that contract is load-bearing.

`shared.vape` remains the single global anchor; downstream files open with `local vape = shared.vape`.

## 3. Compiled layout — match `InhalerCompiled` exactly

The output tree is what `loader.lua`/`main.lua` download, so its **shape is fixed**. Do not invent folders, do not rename files.

```
InhalerObsidianCompiled/
├── loader.lua                    # = src/loader.lua, CDN url swapped
├── main.lua                      # = src/main.lua, CDN url swapped
├── libraries/
│   ├── backend.lua               # Inhaler worker transport (factory) — required
│   ├── drawing.lua               # Actor bridge
│   ├── entity.lua                # entitylib
│   ├── hash.lua                  # sha512
│   ├── prediction.lua            # ballistics
│   ├── vm.lua                    # Fiu VM (jailbreak)
│   └── webhook.lua               # Discord poster
├── guis/
│   └── new.lua                   # **the Obsidian GUI** — one bundled chunk
├── games/
│   ├── universal.lua
│   └── <PlaceId>.lua             # one per product, plus redirect files
└── assets/
    └── new/                      # png icons, only if the Obsidian build still uses them
```

Naming rules, inherited from the bundler:

- `games/<game>/<PlaceId> - <desc>/` compiles to `games/<PlaceId>.lua` — **the text before the first ` - `** is the filename.
- A redirect is a standalone `<PlaceId> - <desc>.lua` at the game-folder root; it is copied verbatim as `games/<PlaceId>.lua`.
- A product chunk is `base.lua` first, then every category folder in the fixed order `Combat, Blatant, Render, Utility, World, Inventory, Legit`, files sorted with `localeCompare`.
- Each category file is appended **wrapped in `run(function() … end)` with one leading tab per line, unless the file text already contains the literal `run(`**. That literal is a marker, not a call — do not reword it in a module.
- Files whose name contains `- dev` are skipped outside dev builds.

`guis/new.lua` is a single flat chunk. In the Vape build it is `guis/new/base.lua` with three markers expanded (`--Libraries`, `--Init`, `--Components`); the Obsidian build keeps the same one-file output for the same reason — `main.lua` downloads exactly one GUI file and `loadstring`s it.

## 4. The GUI port — what `vape` must still provide

`guis/new.lua` returns the `vape` table and `main.lua` assigns it to `shared.vape`. Every game module and every option in `src/games/**` calls into that table, so **the surface below is frozen**. Obsidian only replaces *how* each one is drawn.

### 4.1 Object root

`vape` must still expose these fields; anything reading them is outside the GUI.

| Field | Meaning |
|---|---|
| `Version` | `'4.22'` — shown by overlays and `sessioninfo` |
| `Place` | `game.PlaceId`, overwritten by a redirect with the parent id |
| `Profile` | active save profile, default `'default'` |
| `Loaded` | three-state sentinel, see §4.3 |
| `ThreadFix` | `setthreadidentity and true` |
| `Libraries` | `{entity, whitelist, prediction, hash, webhook, auraanims}` |
| `Categories` | `{Combat, Blatant, Render, Utility, World, Legit, Inventory, …}` |
| `Modules` | every module by name |
| `Legit.Modules` | legit modules by name |
| `Settings` | the GUI settings pane options |
| `Windows`, `ActiveBinds`, `HeldKeybinds`, `RainbowSliders`, `ToggleNotifications`, `SettingToggleNotifications`, `GUIColor` | GUI state other files touch |

### 4.2 Methods

| Method | Contract |
|---|---|
| `vape:Load(skipgui, profile)` | read the profile from disk, apply every option, set `Loaded` |
| `vape:Save()` | write both profile JSON files |
| `vape:SaveOptions` / `vape:LoadOptions` | per-option halves of the above |
| `vape:LoadGUI()` | build the whole UI; in the Obsidian build this is the Obsidian window |
| `vape:Uninject()` | tear down: `backend:stop()`, unload Obsidian, clear `Loaded` |
| `vape:Clean(x)` | register a connection / Instance / thread / function for teardown |
| `vape:Remove(name)` | destroy a module by name (`Modules`, then `Legit.Modules`, then `Categories`) |
| `vape:CreateNotification(title, text, duration, kind)` | `kind` ∈ `'info' \| 'warning' \| 'alert'` → **map to `Library:Notify`** |
| `vape:CreateCategory(name)` / `:CreateCategoryList(name)` | container factories |
| `vape:CreateOverlay(props)` | floating draggable panel → **`Library:AddDraggableMenu`** |
| `vape:UpdateGUI` / `:UpdateGUIQueue` | deferred repaint helpers |
| `vape:SortCategories` | reorder module cards after a toggle |
| `vape:BlurCheck` | blur/lock check used by `canClick` |

### 4.3 `vape.Loaded` is a three-state sentinel

`false` → set to `canSave` at the end of `Load` → `nil` in `Uninject`.

Modules depend on it: `repeat … until vape.Loaded == nil` to exit and `repeat task.wait() until vape.Loaded` to wait. **Obsidian's `Library:Unload()` must not be the only thing that clears it** — set `vape.Loaded = nil` yourself, because modules never see the library object.

Register every `RBXScriptConnection` with `Library:GiveSignal(conn)` **and** keep `vape:Clean(conn)` working; the two teardown paths must agree.

### 4.4 Component surface — what modules call

A module is created by `vape.Categories.<Cat>:CreateModule({Name, Function, ...})` and then gets options from `module:CreateXxx({...})`. Obsidian has no equivalent, so **the adapter is yours**: each `CreateXxx` maps onto one Obsidian element and returns an object that still answers the Vape methods the modules use.

| Vape call | Obsidian mapping |
|---|---|
| `CreateModule({Name, Function})` | `Groupbox:AddToggle(id, {Text = Name, Callback = Function})`, plus a settings box for its options |
| `CreateTargets({Players, NPCs, Walls})` | toggle trio inside a dependency box; saved under the hardcoded key `"Targets"` |
| `CreateToggle` | `AddToggle` — `.Enabled` → `.Value` |
| `CreateSlider` | `AddSlider` — `.Value`, `.Max` |
| `CreateTwoSlider` | **no equivalent**: build two `AddSlider`s, or an `AddInput` pair; must still save `{ValueMin, ValueMax}` |
| `CreateDropdown` | `AddDropdown` — `.Value`; `.Change(list)` → `Dropdown:SetValues` |
| `CreateTextBox` | `AddInput` |
| `CreateTextList` | `AddInput` + `AddDropdown(Multi)`; saves `{List, ListEnabled}` |
| `CreateColorSlider` | `AddColorPicker` — saves `{Hue, Sat, Value, Opacity, Rainbow}`; `Rainbow` is Vape-only, keep it in the save shape |
| `CreateBind` | `AddKeyPicker` — saves `{Keys, Mobile, Hold}`; the module bind uses key `"Bind"` |
| `CreateButton` / `CreateDivider` | `AddButton` / `AddDivider` — save nothing |
| `CreateImageToggle` | `AddToggle` (Obsidian has no image toggle) |
| `LegitWindow:CreateModule` | module whose options live in `Module.Children`; accepts `Size` |

**The save shapes are a wire format.** `vape:Save` writes them and older profiles read them back; changing a key silently resets every user's setting. Convert *inside* `CreateXxx`, never in the profile code.

`AddDropdown` with dictionary `Values` uses the **key** as identity — `Default`, `SetValue` and `OnChanged` all speak keys, never labels. Vape's `.Value` is the label. Convert at the boundary.

### 4.5 Persistence is unchanged

`vape:Save` still writes two JSON blobs (`v = 1`):

- `newvape/profiles/<game.GameId>.gui.txt` — `{Categories, Profile, v}` (layout of non-overlay categories)
- `newvape/profiles/<Profile><Place>.txt` — `{Modules, Categories, Legit, v}` (module state + overlay categories)

A module entry is `{Enabled, Visible, Bind = {Keys, Mobile, Hold}, Options = {...}}`. `v ~= 1` drops `guiData.Categories.Main` and migrates legacy single-key binds. Corrupt JSON degrades to `{Categories = {}}`, raises an `alert` notification and sets `canSave = false`.

**Obsidian's `SaveManager` is not a substitute.** It serialises *its* options to *its* folder. Inhaler's profile format must stay as-is or every existing user loses their config. If you use `SaveManager` at all, use it only for the Obsidian-native theme/config section, never for module state.

## 5. UI mapping rules

**Read `ObsidianUI.md` (repo root, 2035 lines) before authoring anything in this section.** The table below only says *which* Obsidian concept to reach for; `ObsidianUI.md` says *how to call it* — exact signatures, defaults, argument order, and the gotchas per element. Treat the two as a pair: map here, look up there, then write. `Appendix A` at the bottom of this file is the same material compressed, and it is for orientation only — when they disagree, `ObsidianUI.md` wins.

| Vape concept | Obsidian |
|---|---|
| category sidebar | `Window:AddTab(name, icon)` |
| module list inside a category | `Tab:AddGroupbox({Side = "Left", Name = …})` per sub-pane |
| module card | `AddToggle` (+ `AddSettings` for its options) |
| friends / targets / profiles lists | `AddDropdown({Multi = true, SpecialType = "Player"})` |
| search bar | `Window`'s built-in search (`DisableSearch = false`) |
| notifications | `Library:Notify({Title, Description, Time, Icon})` |
| tooltips | element `Tooltip` |
| bind indicators / overlays | `Library:AddDraggableLabel` / `AddDraggableMenu` |

Two Obsidian behaviours that will bite:

1. **`SetIconModule` must run before any UI is created** (`ObsidianUI.md` §16.2 / §21.1).
2. **`Library.KeybindFrame` and `Library.KeybindMenu` only exist after `CreateWindow()`.**

## 6. Libraries — what can be copied and what must be re-pointed

`src/libraries/` and `src/guis/new/libraries/` are two different things and only one of them changes.

| library | Obsidian build |
|---|---|
| `entity.lua` | unchanged — pure gameplay, no UI |
| `hash.lua` | unchanged |
| `prediction.lua` | unchanged |
| `vm.lua` | unchanged |
| `drawing.lua` | unchanged (Actor bridge) |
| `webhook.lua` | unchanged (Discord poster, loaded through `pcall`) |
| `backend.lua` | **must be present** — worker transport (`§0`); it is a factory returning `{start, stop, beat}` |

That is all seven files in `src/libraries/`; none of them draw anything. The UI libraries live in a **different** folder, `src/guis/new/libraries/` — `color`, `getfontbounds`, `getvapeasset`, `tween`, `uipallet` — and those are the ones that must be re-pointed at Obsidian:

- **`uipallet`** → `Library.Scheme` (`BackgroundColor`, `MainColor`, `AccentColor`, `OutlineColor`, `FontColor`, `RedColor`, `DarkColor`, `WhiteColor`). Do not keep a second palette; theme changes must reach the UI.
  **Do not carry the Vape build's font over.** `InhalerV4ForRoblox/src/guis/new/libraries/uipallet.lua` sets `Font = Font.fromEnum(Enum.Font.Arimo)` for the Vape click GUI; the Obsidian build must keep Obsidian's own font (`Library.Scheme.Font`, the `Window.Font` default `Enum.Font.Code`, or whatever the theme supplies). Copying `Arimo`/`Arial`/`Font.fromEnum`/`Font.new('rbxasset://fonts/families/…')` into `guis/new.lua` is a bug, not a port: Obsidian owns its typography, and a hard-coded family overrides the theme picker. The same applies to the two `CreateFont` defaults in `overlays/TextGUI.lua` and `overlays/TargetInfo.lua` — leave them at the Vape default in the source and drop the option from the Obsidian port if it has no equivalent.
- **`color`** → keep `vape.Color` / `vape.TextColor` working (game modules call them); reimplement on top of the scheme colours above rather than a private table.
- **`tween`** → `TweenInfo` against the Obsidian frame, or Obsidian's own animations.
- **`getvapeasset`** → `Library.ImageManager` / `Library:GetCustomIcon`; keep the inline `rbxassetid://` fallback and keep returning `''` on a miss.
- **`getfontbounds`** → `Library:GetTextBounds`.
- **`vape:CreateNotification`** → `Library:Notify`.

**`Uninject` is the one that breaks quietly.** `vape:Uninject()` must `Library:Unload()` (which disconnects every `GiveSignal` connection and destroys the ScreenGui) **and** clear `vape.Loaded = nil` and stop `backend`. A re-inject that leaves an Obsidian ScreenGui behind stacks two windows and leaks the keybind menu.

## 7. Known pitfalls

- **Hand edits are erased.** This repo is generated. Fix `src/`.
- **Do not rename the GUI file.** `main.lua` hardcodes `newvape/guis/new.lua` and the folder name `'new'`.
- **`ChangeTarget`'s `Visible` is never saved.** A sub-option under an already-enabled parent must be re-applied on enable.
- **`CreateTargets` always writes its state under the literal key `"Targets"`** (`components/Targets.lua:137`), ignoring `Name`; only one targets object per module survives a save.
- **`TwoSlider` never calls `props.Function` from `SetValue`** (`components/TwoSlider.lua:128` only writes state and tweens). Preserve or fix deliberately, not by accident.
- **`vape:Remove` only affects modules alive at call time**: a product base runs before its own category files.
- **`Dropdown:SetValue` silently falls back to the first entry** when the value is missing — a renamed option quietly resets. Obsidian behaves the same way with dictionary keys.
- **`Enabled and nil or true` is always `true`.** Pass booleans through unchanged.
- **Two scopes per product**: `base.lua` shares one with unwrapped files (any file whose text contains `run(`), where a duplicated top-level local silently overwrites the other's; wrapped files are isolated. A top-level `return` is only legal in a wrapped module.
- **`bedwars/6872274481 - game/base.lua:33` kicks the player** — BedWars is retired; do not build it into a test loop.
- **Obsidian's `AlwaysOnTop` is executor-only**, and `SaveManager` is unavailable in Studio.

## 8. Building this from scratch — you are the bundler

There is **no** `InhalerBundlerObsidian` in the workspace and no CI. To produce this repo you reconstruct the bundler. Read `../InhalerBundler/` first — it is ~200 lines and it *is* the specification.

**Do not create a permanent bundler either.** You are the bundler: run the steps below by hand (or with throwaway one-off commands and scratch scripts outside both repositories), then throw the scaffolding away. No `InhalerBundlerObsidian/` folder, no `package.json`, no build tooling checked in anywhere. The one exception is a vendored `vendor/Obsidian/` if you need it to keep the build reproducible — that is content, not a build system.

### 8.0 `InhalerV4ForRoblox/` is read-only for a build

A build **reads** the source tree and writes only into `InhalerObsidianCompiled/`. Nothing else.

| Action | Allowed during a build |
|---|---|
| `cat` / `grep` / `Read` a file under `InhalerV4ForRoblox/` | yes |
| `cp` / `node` / `sed` **into a temp dir** derived from it | yes |
| edit, create, delete, `git add`, `git commit`, `git push` **in** `InhalerV4ForRoblox/` | **no** |
| `git status` there printing anything but "clean" | **stop and report** |

Run `git status --short` in `../InhalerV4ForRoblox` **before** starting and **after** the build. Both must be empty. A non-empty result means the build was not read-only — report it to the user instead of committing the output, because you would be shipping a build whose source no longer matches `main`.

The only legitimate reason to touch the source is a user request to change gameplay or GUI code. That is a normal source task (`InhalerV4ForRoblox/AGENTS.md`), not part of compiling this repo, and it is never implied by "compile the Obsidian build".

### 8.1 What the reference bundler does

`../InhalerBundler/index.js`:

1. Reads `config.json` → `{SRC_PATH, PROD_PATH, DEV_PATH}`.
2. Creates `PROD_PATH` plus `assets/`, `libraries/`, `games/`, `guis/`.
3. `loader.lua` and `main.lua` are **copied verbatim**.
4. Every file in `src/libraries/` is **copied verbatim** into `libraries/`. (The Obsidian build rewrites some of them — `§6` — so copy-and-patch, do not copy-and-forget.)
5. For each folder in `src/guis/`, `processUI.js` builds one chunk.
6. For each folder/file in `src/games/`, `processGame.js` builds one chunk.

`helpers/processUI.js` — the GUI chunk:

- reads `assets/` → copied to `assets/<name>/`
- reads `libraries/`, `overlays/`, `components/`, sorting **libraries ascending, overlays descending, components ascending** by name
- every component line is indented one extra tab
- substitutes three markers in `base.lua`:
  - `--Libraries` → the GUI libraries concatenated, plus a `vape.Libraries = { … }` table
  - `--Components` → `components = { <Name> = function(props, children, api) … end, … }`
  - `--Init` → `init.lua`, with each overlay wrapped in `run(function() … end)` at its own `--Overlays` marker, then the whole thing indented one tab
- writes `guis/<name>.lua`

`helpers/processGame.js` — a product chunk:

- `name.split(' - ')[0]` is the output filename
- `base.lua` first
- then categories in the fixed order, files sorted `localeCompare`
- each file wrapped in `run(function() … end)` **unless its text contains the literal `run(`**
- skips `- dev` files outside dev builds
- a `.lua` file at the root is copied verbatim

### 8.2 What you must change for Obsidian

Only **step 5** differs, and only inside `guis/`:

- The output is still `guis/new.lua`, still one chunk.
- `base.lua` keeps the frozen `vape` surface (`§4`) but its body becomes the Obsidian adapter.
- `components/*` are **not** inlined as Vape components any more. Either keep the marker and emit Obsidian-backed adapters, or drop `--Components` and build the UI directly in `--Init`. Whichever you pick, `base.lua` must still `return vape`.
- `init.lua` becomes the Obsidian window: `Library:CreateWindow` → `AddTab` per category → `AddGroupbox` per pane.
- `assets/` may be dropped if nothing references the pngs; Obsidian draws its own icons through Molto. If you keep it, keep the folder name `new`.

### 8.3 Vendor Obsidian

Do **not** fetch `Library.lua` at runtime from `deividcomsono/Obsidian`. Vendor it:

```bash
mkdir -p vendor/Obsidian/addons
curl -o vendor/Obsidian/Library.lua            https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua
curl -o vendor/Obsidian/addons/ThemeManager.lua https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua
curl -o vendor/Obsidian/addons/SaveManager.lua  https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua
```

Then **inline** `Library.lua` at the top of `guis/new.lua` as a local, the way Vape inlines its GUI libraries — one file in, one file out, no extra request at inject time and no third-party URL in the boot path.

### 8.4 Build recipe

```bash
# 1. sources
cd "/home/nebelnight/文档/VSCode/Inhaler Development"
git clone https://github.com/Night5449791/InhalerV4ForRoblox.git   # if absent

# 2. bundler
mkdir -p InhalerBundlerObsidian/helpers && cd InhalerBundlerObsidian
# port index.js + helpers/{processGame,processUI,vars}.js from ../InhalerBundler/
cat > config.json <<'EOF'
{
    "DEV_PATH": "./InhalerObsidianDevelopment",
    "PROD_PATH": "./InhalerObsidianCompiled",
    "SRC_PATH": "../InhalerV4ForRoblox/src"
}
EOF
bash scripts/fetch-obsidian.sh

# 3. build
node index.js prod
```

Expected output, matching `§3`:

```
InhalerObsidianCompiled/
├── loader.lua        (the copied src/loader.lua, CDN swapped)
├── main.lua          (the copied src/main.lua, CDN swapped)
├── libraries/        (the seven src/libraries/*.lua, copied)
├── guis/new.lua      (the Obsidian chunk)
├── games/*.lua       (universal + one per product)
└── assets/new/       (only if kept)
```

### 8.5 Verify before committing

1. Every `.lua` under `games/` and `libraries/` parses after the Luau rewrite (`§1`).
2. `guis/new.lua` **ends with `return vape`** and contains at most one `Library = loadstring(...)` (the inlined vendor).
3. Grep for leftovers: `grep -rn "uipallet\|components\.\|ScreenGui" guis/new.lua` should only show intentional adapter code.
4. `grep -c "watermark" loader.lua` ≥ 1 — the cache invalidation still works.
5. The four runtime paths work: a fresh inject, a re-inject (no stacked window), a teleport reload, `Uninject`.
6. Diff the tree against `§3` — a missing `games/<PlaceId>.lua` means a product silently stops loading.

### 8.6 Commit and push automatically, every time

Once §8.5 passes, **commit and push without asking** — a compiled build that only exists on the local disk is a build nobody can inject. The user's "compile the Obsidian build" already includes this step.

```bash
cd InhalerObsidianCompiled
git add -A
git commit -m "compiled obsidian build"
git push origin main
```

Rules:

- **Use the proxy** the workspace expects: `export https_proxy=http://localhost:7890 http_proxy=http://localhost:7890` before `git push`. It is the only network path in this machine.
- **One commit per build.** Do not squash several builds together and do not amend an already pushed commit.
- **Never force-push**, never rebase a pushed history, never `git reset --hard` on anything already on `origin`.
- The message stays short and mechanical (`compiled obsidian build`, or `compiled obsidian build: <what changed>` when the source diff is interesting). This repo is output; the story lives in `InhalerV4ForRoblox/UPDATES.md`.
- **`AGENTS.md` itself belongs in this repo and is committed with everything else.** It is the one hand-maintained file here — it documents the build, so a build that changes the process should carry the doc change with it.
- After pushing, verify: `git rev-parse HEAD origin/main` must print the same sha. Report the commit sha to the user.
- `git push` failing on `credential-manager` is a harmless local-helper warning; a non-zero exit from the `push` line itself is not — surface the real error instead of retrying blindly.

## 9. Conventions

1. **Tabs, no semicolons**, no collapsed multi-argument calls.
2. Localize aggressively — never index a field or call a function twice in a loop; hoist per-frame constants.
3. Route all cleanup through `vape:Clean(...)` / `<Module>:Clean(...)` **and** `Library:GiveSignal(...)`; a raw `:Connect()` leaks across reinjection.
4. Module loops: `repeat … task.wait() until not Module.Enabled`. The framework spawns `Function`; never spawn your own thread for it.
5. Prefer guarded executor calls (`typeof(x) == 'function'`, `pcall`) over raw calls with live game objects.
6. Keep `UPDATES.md` out of this repo: it is a source-side changelog (`InhalerV4ForRoblox/AGENTS.md` §11).

---

## Appendix A. Obsidian UI reference

> Condensed from the full official documentation at <https://docs.mspaint.cc/obsidian> (37 pages).
> Obsidian is a clean Roblox UI library by **deivid** for the [mspaint script hub](https://www.mspaint.cc).
> Its API is deliberately modelled after [LinoriaLib](https://github.com/mstudio45/linorialib) — the two are API-compatible.
> Upstream: <https://github.com/deividcomsono/Obsidian> · License/credits: deivid

---

### Contents

1. [Overview & Features](#1-overview--features)
2. [Installation](#2-installation)
3. [Structure Model](#3-structure-model)
4. [Window](#4-window)
5. [Tabs](#5-tabs)
6. [Groupboxes](#6-groupboxes)
7. [Tabboxes](#7-tabboxes)
8. [Dependency Boxes](#8-dependency-boxes)
9. [UI Elements](#9-ui-elements)
10. [Library Core](#10-library-core)
11. [Loading Screen](#11-loading-screen)
12. [Notifications](#12-notifications)
13. [Dialogs](#13-dialogs)
14. [Overlays](#14-overlays)
15. [Keybind Menu](#15-keybind-menu)
16. [Utility & Helpers](#16-utility--helpers)
17. [Addons: ThemeManager](#17-addon-thememanager)
18. [Addons: SaveManager](#18-addon-savemanager)
19. [Options Registry & Callback Pattern](#19-options-registry--callback-pattern)
20. [Deprecated APIs](#20-deprecated-apis)
21. [Gotchas & Best Practices](#21-gotchas--best-practices)
22. [Quick-Start Template](#22-quick-start-template)

---

### A.1. Overview & Features

Obsidian is a Roblox UI library. Advertised features:

- Clean and simple UI
- **Full Mobile and PC support** (tap-friendly controls, mobile toggle/lock buttons)
- Customizable themes (built-in palette + ThemeManager addon)
- **Built-in Save Manager** (config save/load/autoload)
- Maintained, actively developed

Runs in four environments:

| Environment | Notes |
| --- | --- |
| **Executor** | Primary target. `loadstring` + `game:HttpGet`. Full features including file-backed SaveManager/ThemeManager. |
| **Roblox Studio** | Copy `Library.lua` into a ModuleScript and `require` it. Only ThemeManager available (cannot save themes). |
| **Next.js + Tailwind** | React replica installed via shadcn/ui CLI. May differ slightly from the Lua version. |
| **Vanilla HTML** | Web-component widget (`<Obsidian>`), driven by JSON UI data or nested JSON. |

---

### A.2. Installation

#### A.2.1 Executor

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
```

Optional type definitions for `luau-lsp` autocompletion:
<https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.d.luau>

Addons are loaded separately:

```lua
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
```

#### A.2.2 Roblox Studio

```lua
local Library = require(game:GetService("ReplicatedStorage"):WaitForChild("Obsidian"))
```

Icons (requires [Molto](https://raw.githubusercontent.com/notpoiu/Molto/refs/heads/main/source.lua)):

```lua
local Library = require(game:GetService("ReplicatedStorage"):WaitForChild("Obsidian"))
local Icons = require(game:GetService("ReplicatedStorage"):WaitForChild("Molto"))
Icons.SetProvider("lucide")

Library:SetIconModule(Icons)
```

> **Warning:** call `SetIconModule` **before creating any UI** (e.g. before the window).

ThemeManager in Studio: copy `addons/ThemeManager.lua` into a ModuleScript and require it.
SaveManager is **not** available in Studio.

#### A.2.3 Vanilla HTML

```html
<head>
  <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
  <script src="https://www.mspaint.cc/widgets/obsidian.js"></script>
  <style>
    .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
    .no-scrollbar::-webkit-scrollbar { width: 0; height: 0; display: none; }
  </style>
</head>
<body>
  <Obsidian
    title="mspaint"
    footer="version: example"
    icon="https://www.mspaint.cc/icon.png"
    ui-data-src="https://raw.githubusercontent.com/mspaint-cc/webmspaint/refs/heads/main/registry/obsidian-demo/ObsidianExtracted.json">
  </Obsidian>
</body>
```

Inline JSON alternative:

```html
<Obsidian title="mspaint" footer="version: example" icon="https://www.mspaint.cc/icon.png">
  <script type="application/json">
    { "tabs": { "Home": { "order": 1, "groups": [] } } }
  </script>
</Obsidian>
```

Dump an existing UI to JSON (`ObsidianExtracted.json` in executor workspace):

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/mspaint-cc/assets/refs/heads/main/uidata/extractor.lua"))()
```

#### A.2.4 Next.js + Tailwind

```bash
pnpm dlx shadcn@latest add "https://www.mspaint.cc/r/obsidian"
# or: npx / yarn / bunx --bun
```

Add `.no-scrollbar` CSS to `global.css`, then:

```tsx
import {
  Obsidian, ObsidianTab, ObsidianLeft, ObsidianRight, ObsidianGroupbox,
  ObsidianTabWarning, ObsidianToggle, ObsidianSlider, ObsidianInput,
  ObsidianDropdown, ObsidianButton, ObsidianLabel, ObsidianDivider, ObsidianImage,
} from "@/components/obsidian/obsidian";

<Obsidian title="mspaint" icon="/mspaint.png" footer="version: example">
  <ObsidianTab name="General" order={0} icon="Settings">
    <ObsidianLeft>
      <ObsidianGroupbox name="Basics" order={0}>
        <ObsidianToggle text="Enable feature" defaultChecked />
        <ObsidianSlider text="Opacity" min={0} max={100} value={80} suffix="%" />
        <ObsidianInput text="Display name" placeholder="Type your name" />
        <ObsidianDivider />
        <ObsidianDropdown text="Mode" options={["Simple", "Advanced"]} />
        <ObsidianButton text="Apply" />
      </ObsidianGroupbox>
    </ObsidianLeft>
    <ObsidianRight>
      <ObsidianGroupbox name="Info" order={0}>
        <ObsidianLabel text="This is a label." />
        <ObsidianImage text="Logo" image="/next.svg" height={200} />
      </ObsidianGroupbox>
    </ObsidianRight>
  </ObsidianTab>
</Obsidian>
```

Or pass dumped JSON via `uiData={UIData}`.

#### A.2.5 Contributing

- Conventional Commits format
- **Spaces** for indentation (not tabs)
- PRs must describe what changed and why

---

### A.3. Structure Model

Obsidian nests like this:

```
Library
└── Window                 (CreateWindow)
    ├── Tab                (AddTab / AddCustomTab / AddKeyTab)
    │   ├── Groupbox       (Side = "Left" | "Right")
    │   │   └── Elements   (Toggle, Slider, Dropdown, ...)
    │   └── Tabbox         (Side = "Left" | "Right")
    │       └── Tab        (AddTab inside tabbox → acts like a groupbox)
    │           └── Elements
    └── Dialog             (AddDialog)
```

Key points:

- **Tabs** show on the left sidebar; each has name, optional icon and description.
- The tab content area is split into **two columns (left/right)**.
- **Groupboxes and tabboxes** live inside those columns; each holds any UI element.
- **Dependency boxes** are invisible containers inside groupboxes that show/hide children based on other options.
- Elements (toggles, labels, buttons) can host **KeyPickers**, **ColorPickers** and **Settings** boxes.

---

### A.4. Window

The base UI container. Created once.

```lua
local Window = Library:CreateWindow({
    Title = "mspaint",
    Footer = "version: example",
    Icon = 95816097006870,
    NotifySide = "Right",
})
```

#### A.4.1 Configuration

| Key | Description | Type | Default | Req |
| --- | --- | --- | --- | --- |
| `Title` | Title at top of window | string | `"No Title"` | **yes** |
| `Footer` | Footer text at bottom | string | `"No Footer"` | **yes** |
| `Position` | Initial position | UDim2 | `UDim2.fromOffset(6, 6)` | no |
| `Size` | Window size | UDim2 | `UDim2.fromOffset(720, 600)` | no |
| `Center` | Center on screen | boolean | `true` | no |
| `AutoShow` | Show immediately | boolean | `true` | no |
| `ToggleKeybind` | UI toggle key | Enum.KeyCode | `Enum.KeyCode.RightControl` | no |
| `NotifySide` | `"Left"` or `"Right"` | string | `"Right"` | no |
| `ShowCustomCursor` | Render Obsidian cursor | boolean | `true` | no |
| `AlwaysOnTop` | Stay above Roblox core blur (**executor only**) | boolean | `false` | no |
| `Font` | Text font | Enum.Font | `Enum.Font.Code` | no |
| `CornerRadius` | Corner radius of elements | number | `4` | no |
| `Icon` | Window icon (string/asset ID) | string/ID | `nil` | no |
| `IconSize` | Icon size | UDim2 | `UDim2.fromOffset(30, 30)` | no |
| `BackgroundImage` | Window background image | string/ID | `nil` | no |
| `Resizable` | Allow resize | boolean | `true` | no |
| `ShowMobileButtons` | Show mobile Toggle/Lock buttons | boolean | `true` | no |
| `MobileButtonsSide` | `"Left"` \| `"Right"` | string | `"Left"` | no |
| `DisableSearch` | Disable search box | boolean | `false` | no |
| `SearchbarSize` | Searchbar size | UDim2 | `UDim2.fromScale(1, 1)` | no |
| `GlobalSearch` | Search across all tabs | boolean | `false` | no |
| `UnlockMouseWhileOpen` | Free the mouse even when cursor is locked (e.g. first person) | boolean | `true` | no |
| `EnableSidebarResize` | Draggable sidebar resize handle | boolean | `false` | no |
| `EnableCompacting` | Allow sidebar compacting | boolean | `true` | no |
| `DisableCompactingSnap` | Disable snap while compacting | boolean | `false` | no |
| `SidebarCompacted` | Start in icon-only mode | boolean | `false` | no |
| `MinContainerWidth` | Min content width (px) | number | `256` | no |
| `MinSidebarWidth` | Smallest width before compact mode | number | `128` | no |
| `SidebarCompactWidth` | Width while compacted | number | `48` | no |
| `SidebarCollapseThreshold` | Ratio (0–1) that triggers snap to compact while dragging | number | `0.5` | no |
| `CompactWidthActivation` | Width threshold triggering compact while dragging | number | `128` | no |
| `Snapping` | Snap window to edges/center while dragging | boolean | `false` | no |
| `SnapDistance` | Snap proximity in px | number | `28` | no |
| `SnapMargin` | Padding from edge when snapped | number | `8` | no |
| `SnapAvoidCoreGui` | Keep snap targets in safe area | boolean | `true` | no |
| `Animations` | Enable animations table | table | `{ToggleWindow=false, TabSwitch=false, Groupbox=false, Dropdown=false, KeyPicker=false}` | no |
| `TabTransitionTime` | Tab swipe duration (s) | number | `0.22` | no |
| `TabSwipeOffset` | Tab slide distance (px) | number | `26` | no |
| `TabSwipeFrom` | `"left"\|"right"\|"top"\|"bottom"` | string | `"bottom"` | no |
| `TabButtonsStyle` | Sidebar tab button styling | table | `{Gap=0, Padding=0, CornerRadius=0, Indicator=false, IndicatorWidth=2, IndicatorHeight=20}` | no |

#### A.4.2 Methods

| Method | Description |
| --- | --- |
| `Window:ChangeTitle(title)` | Change window title |
| `Window:SetFooter(text)` | Change footer |
| `Window:SetAlwaysOnTop(bool)` | Stay above core blur (executor only) |
| `Window:SetBackgroundImage(img)` | Change background image |
| `Window:SetCornerRadius(n)` | Change element corner radius |
| `Window:SetSnapping(enabled, dist?, margin?, avoidCoreGui?)` | Enable/update edge & center snapping |
| `Window:Toggle(state?)` | Show/hide window (optionally force a state) |
| `Window:ShowTabInfo(name, description)` | Show current tab name/description in header |
| `Window:HideTabInfo()` | Hide tab info, restore searchbar width |
| `Window:GetSidebarWidth()` | Current sidebar width in px |
| `Window:IsSidebarCompacted()` | Whether sidebar is icon-only |
| `Window:SetSidebarWidth(px)` | Resize sidebar (clamped) |
| `Window:SetCompact(bool)` | Force compact / restore last expanded width |
| `Window:SetAnimations(config?, time?, offset?, from?)` | Update animation config |

#### A.4.3 Animations

```lua
local Window = Library:CreateWindow({
    Title = "mspaint",
    Animations = {
        ToggleWindow = true,
        TabSwitch = true,
        Groupbox = true,
        Dropdown = true,
        KeyPicker = true,
    },
    TabTransitionTime = 0.22,
    TabSwipeOffset = 26,
    TabSwipeFrom = "bottom",
})
```

`ToggleWindow` animates open/close, `TabSwitch` the tab transition, `Groupbox`/`Dropdown`/`KeyPicker` their expand interactions.

#### A.4.4 Sidebar Layout & Resizing

```lua
local Window = Library:CreateWindow({
    Title = "mspaint",
    EnableSidebarResize = true,
    MinSidebarWidth = 200,
    SidebarCompactWidth = 56,
})
```

#### A.4.5 Tab Buttons Style

```lua
TabButtonsStyle = {
    Gap = 4,              -- vertical spacing between buttons
    Padding = 8,          -- padding around list (also affects min sidebar widths)
    CornerRadius = 6,     -- per-button corner radius
    Indicator = true,     -- accent bar on active tab
    IndicatorWidth = 2,
    IndicatorHeight = 20,
}
```

---

### A.5. Tabs

Tabs separate sections. Order follows `AddTab` call order (or `Order`).

```lua
local Tabs = {
    Main = Window:AddTab("Main", "user"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}
```

#### A.5.1 Positional Arguments — `AddTab(name, icon?, description?, order?)`

| Arg | Description | Type |
| --- | --- | --- |
| 1 | Name of the tab | string |
| 2 | Lucide icon name or custom icon | string |
| 3 | Tab description | string |
| 4 | Layout order | number |

#### A.5.2 Configuration Table

```lua
local Tab = Window:AddTab({
    Name = "Main",
    Description = "Main features",
    Icon = "home",
    Tooltip = "Main features for the game",
    Order = 1,
})
```

| Key | Description | Type | Req |
| --- | --- | --- | --- |
| `Name` | Tab name | string | **yes** |
| `Description` | Tab description | string | no |
| `Icon` | Lucide icon name or custom icon | string | no |
| `Tooltip` | Hover tooltip on tab button | string | no |
| `Order` | Layout order (defaults to creation order) | number | no |

#### A.5.3 Tab Methods

| Method | Description |
| --- | --- |
| `Tab:UpdateWarningBox({...})` | Show a warning/error/info box |
| `Tab:SetVisible(bool)` | Show/hide tab |
| `Tab:SetOrder(n)` | Change tab order |
| `Tab:SetTooltip(text?)` | Set/clear tab tooltip |
| `Tab:SetName(name)` | Rename tab |
| `Tab:SetDescription(desc)` | Update description |
| `Tab:SetIcon(icon)` | Update icon |

##### UpdateWarningBox config

```lua
Tab:UpdateWarningBox({
    Title = "Warning",
    Text = "Example",
    IsNormal = false,  -- false = red error box, true = normal style
    Visible = true,
    LockSize = true,
})
```

#### A.5.4 Custom Tabs

Empty container instead of the usual groupbox columns — build your own UI, still get a normal tab button.

```lua
local Container, CustomTab = Window:AddCustomTab("Custom", "layout-dashboard")

-- or table form
local Container, CustomTab = Window:AddCustomTab({
    Name = "Custom",
    Icon = "layout-dashboard",
    Description = "My own UI",
    Tooltip = "Custom tab",
    Order = 1,
})
```

Returns `(Frame, table)`.

Methods: `CustomTab:Show()`, `:Hide()`, `:SetVisible(bool)`, `:SetOrder(n)`, `:SetTooltip(text)`, `:Destroy()`.

```lua
local Container, CustomTab = Window:AddCustomTab("Custom", "layout-dashboard")

local Label = Instance.new("TextLabel")
Label.BackgroundTransparency = 1
Label.Size = UDim2.fromScale(1, 1)
Label.Text = "Hello from a custom tab!"
Label.TextColor3 = Library.Scheme.FontColor
Label.Parent = Container
```

#### A.5.5 Key Tabs

Key tabs render content **centered**, intended for key-system pages. Inherits all groupbox/tabbox methods.

```lua
local KeyTab = Window:AddKeyTab("Key System", "key")

KeyTab:AddLabel({ Text = "mspaint key system", DoesWrap = true, Size = 20 })
KeyTab:AddLabel({ Text = "Your support helps us keep developing, thank you!", DoesWrap = true, Size = 16 })

KeyTab:AddKeyBox(function(ReceivedKey)
    local Success = ReceivedKey == "Banana"  -- your own check
    print("Expected Key: Banana | Success:", Success)
    Library:Notify("Success: " .. tostring(Success), 4)
end)
```

> `AddKeyBox` only takes the callback — you implement the key validation yourself.

---

### A.6. Groupboxes

The basic building block of a tab. Belongs to either the left or right column.

```lua
local LeftGroupBox = Tab:AddGroupbox({
    Side = "Left",                       -- case-insensitive; or 1 / "1"
    Name = "Groupbox",
    Description = "Optional subtitle under the title",
    IconName = "boxes",
    -- Visible = true,
    -- Collapsed = false,
    -- DisableCollapsing = false,
    -- MaxHeight = 300,
    -- PopOut = true,
    -- MaxPopOutHeight = 200,
    -- PopOutWidth = 280,
})

local RightGroupBox = Tab:AddGroupbox({
    Side = "Right",
    Name = "Dropdowns",
})
```

| Key | Description | Type | Default | Req |
| --- | --- | --- | --- | --- |
| `Side` | Column: `"Left"`/`"Right"` (case-insensitive) or `1`/`2` | string/number | — | **yes** |
| `Name` | Title | string | — | **yes** |
| `Description` | Subtitle under title | string | `nil` | no |
| `IconName` | Lucide icon or custom icon | string | `nil` | no |
| `Visible` | Initially visible | boolean | `true` | no |
| `Collapsed` | Initially collapsed | boolean | `false` | no |
| `DisableCollapsing` | Prevent collapsing | boolean | `false` | no |
| `MaxHeight` | Max content height (layout px); overflow scrolls | number | `nil` | no |
| `PopOut` | Hold-drag header to undock into floating panel | boolean | `true` | no |
| `MaxPopOutHeight` | Max body height when popped out (also screen-clamped) | number | `nil` | no |
| `PopOutWidth` | Fixed float width (defaults to docked width) | number | `nil` | no |

#### A.6.1 Methods

| Method | Description |
| --- | --- |
| `Groupbox:SetVisible(bool)` | Set visibility |
| `Groupbox:Show()` | Alias for `SetVisible(true)` |
| `Groupbox:Hide()` | Alias for `SetVisible(false)` |
| `Groupbox:SetDescription(text?)` | Set/clear description |
| `Groupbox:SetMaxHeight(n?)` | Set/clear max content height |
| `Groupbox:SetPoppedOut(bool, pos?)` | Undock/dock (optional float position) |
| `Groupbox:TogglePoppedOut()` | Toggle popped-out state |
| `Groupbox:SetMaxPopOutHeight(n?)` | Set/clear max body height when popped out |
| `Groupbox:SetPopOutWidth(n?)` | Set/clear float width |
| `Groupbox:AddTabbox()` | Create a nested tabbox inside this groupbox |

Dialogs and Settings boxes inherit **all** groupbox methods.

---

### A.7. Tabboxes

Like a groupbox but with internal tabs.

```lua
local LeftTabBox = Tab:AddTabbox({
    Side = "Left",
    Name = "Left Tabbox",
})

local RightTabBox = Tab:AddTabbox({
    Side = "Right",
    Name = "Right Tabbox",
})
```

| Key | Description | Type | Default | Req |
| --- | --- | --- | --- | --- |
| `Side` | Column | string/number | — | **yes** |
| `Name` | Used for SaveManager pop-out persistence | string | `nil` | no |
| `MaxHeight` | Max content height for every tab | number | `nil` | no |
| `PopOut` | Hold-drag tab strip to undock | boolean | `true` | no |
| `MaxPopOutHeight` | Max body height when popped out | number | `nil` | no |
| `PopOutWidth` | Fixed float width | number | `nil` | no |

#### A.7.1 Methods

| Method | Description |
| --- | --- |
| `Tabbox:AddTab(name, icon?, maxHeight?)` | Create a tab (acts as a groupbox) |
| `Tabbox:SetMaxHeight(n?)` | Max height for all tabs |
| `Tab:SetMaxHeight(n?)` | Max height for one tab (`nil` → tabbox value) |
| `Tabbox:SetPoppedOut(bool, pos?)` | Undock/dock |
| `Tabbox:TogglePoppedOut()` | Toggle popped-out |
| `Tabbox:SetMaxPopOutHeight(n?)` | Max body height when popped out |
| `Tabbox:SetPopOutWidth(n?)` | Float width |
| `Tabbox:Resize()` | Resize active tab (auto on content change) |

#### A.7.2 Nested Tabboxes

Tabs inside a tabbox can hold their own tabbox. Leave the name empty to show only the icon.

```lua
local SettingsTab = Tabbox:AddTab("Settings")
local NestedTabbox = SettingsTab:AddTabbox()

local GeneralTab = NestedTabbox:AddTab(nil, "settings")
local AdvancedTab = NestedTabbox:AddTab(nil, "wrench")
```

---

### A.8. Dependency Boxes

Invisible containers inside a groupbox that show/hide their children based on other options' values. Two flavours:

| Type | Factory | Appearance |
| --- | --- | --- |
| **Dependency Box** | `Groupbox:AddDependencyBox()` | Invisible, no chrome |
| **Dependency Groupbox** | `Groupbox:AddDependencyGroupbox()` | Groupbox-like chrome, no title, inherits parent side |

Both share `:SetupDependencies(deps)`.

#### A.8.1 Dependency Box

```lua
local Toggles = Library.Toggles
local LeftGroupbox = MainTab:AddGroupbox({ Side = "Left", Name = "Settings", IconName = "wrench" })

LeftGroupbox:AddToggle("EnableAudio", { Text = "Enable Audio", Default = false })

local AudioSettings = LeftGroupbox:AddDependencyBox()
AudioSettings:AddSlider("Volume", { Text = "Volume", Default = 50, Min = 0, Max = 100, Rounding = 0 })

AudioSettings:SetupDependencies({
    { Toggles.EnableAudio, true },   -- only show if EnableAudio is true
    -- { Options.AudioMode, "Stereo" }, -- AND AudioMode == "Stereo"
})
```

#### A.8.2 Dependency Groupbox

```lua
local AudioSettings = LeftGroupbox:AddDependencyGroupbox()
AudioSettings:AddSlider("Volume", { Text = "Volume", Default = 50, Min = 0, Max = 100, Rounding = 0 })
AudioSettings:SetupDependencies({ { Toggles.EnableAudio, true } })
```

#### A.8.3 SetupDependencies

```lua
DependencyBox:SetupDependencies({
    { OptionRef, ExpectedValue },
    -- ...
})
```

All listed dependencies must match for the children to be shown.

---

### A.9. UI Elements

All elements are added to a **Groupbox**, **Tabbox tab**, **Dialog**, **Settings box**, or the **Loading sidebar**.

#### A.9.0 Common Element Behaviour

Most interactive elements share these config keys:

| Key | Description | Type |
| --- | --- | --- |
| `Text` | Label text | string |
| `Tooltip` | Tooltip on hover | string |
| `DisabledTooltip` | Tooltip shown when disabled | string |
| `Disabled` | Element is non-interactive | boolean |
| `Visible` | Element is rendered | boolean |
| `Risky` | Render text red (destructive action) | boolean |
| `Callback` | Fires on change (docs prefer `OnChanged`) | function |

Every element provides `:Destroy()`. Most provide `:SetText()`, `:SetVisible()`, `:SetDisabled()` and `:OnChanged()`.

---

#### A.9.1 Label — `AddLabel`

```lua
-- positional: (text, doesWrap?, id?)
local Label = Groupbox:AddLabel("This is a label", false)

-- table form
local Label = Groupbox:AddLabel({ Text = "This is a label", DoesWrap = false })

-- with ID for Library.Labels.MyLabel access
local Label = Groupbox:AddLabel("MyLabel", { Text = "This is a label" })
```

| Key | Description | Type | Default |
| --- | --- | --- | --- |
| `Text` | Label text | string | — (**req**) |
| `DoesWrap` | Wrap text | boolean | `true` |
| `Size` | Font size | number | `14` |
| `Visible` | Visible | boolean | `true` |

Methods: `SetText`, `SetSize`, `SetVisible`, `Destroy`.

---

#### A.9.2 Button — `AddButton`

```lua
Groupbox:AddButton("This is a button", function()
    print("Button clicked!")
end)

-- table form
Groupbox:AddButton({
    Text = "This is a button",
    Func = function() print("Button clicked!") end,
})
```

| Key | Description | Type | Default |
| --- | --- | --- | --- |
| `Text` | Button text | string | — (**req**) |
| `Func` | Click callback | function | — (**req**) |
| `Icon` | Lucide icon / asset / URL | string | `nil` |
| `DoubleClick` | Require double-click | boolean | `false` |
| `Tooltip` / `DisabledTooltip` | Hover tooltips | string | `nil` |
| `Risky` | Red text | boolean | `false` |
| `Disabled` | Disabled | boolean | `false` |
| `Visible` | Visible | boolean | `true` |

Methods: `SetIcon(icon?)`, `Destroy`.

##### Sub Buttons

```lua
local MainButton = Groupbox:AddButton({ Text = "Button", Func = function() print("Button clicked!") end })

MainButton:AddButton({
    Text = "Sub Button",
    Func = function() print("Sub button clicked!") end,
})
```

##### KeyPicker on a Button

Only works with **`Press`** mode. When fired via key, callback receives `FromKeyPicker = true`.

```lua
local CoolButton = Groupbox:AddButton({
    Text = "Cool Button",
    Func = function(FromKeyPicker)
        if FromKeyPicker then
            print("Triggered by KeyPicker")
        else
            print("Clicked manually")
        end
    end,
})

CoolButton:AddKeyPicker("ButtonKeyPicker", {
    Default = "V",
    Text = "Button Bind",
    Mode = "Press",
})
```

---

#### A.9.3 Toggle — `AddToggle`

```lua
local MyToggle = Groupbox:AddToggle("MyToggle", {
    Text = "Enable Speed Hack",
    Default = true,
})
```

| Key | Description | Type | Default |
| --- | --- | --- | --- |
| `Text` | Toggle text | string | `"Toggle"` (**req**) |
| `Default` | Initial state | boolean | `false` |
| `Tooltip` / `DisabledTooltip` | Hover tooltips | string | `nil` |
| `Callback` | Change callback | function | `function() end` |
| `Risky` | Red text | boolean | `false` |
| `Disabled` | Disabled | boolean | `false` |
| `Visible` | Visible | boolean | `true` |

Methods: `SetValue(bool)`, `SetText(text)`, `SetDisabled(bool)`, `SetVisible(bool)`, `OnChanged(fn)`, `Destroy`.

> Set `Library.ForceCheckbox = true` to render `AddToggle` as a **checkbox** instead.

---

#### A.9.4 Checkbox — `AddCheckbox`

Identical API and config to **Toggle**, but renders a checkbox. Also affected by `Library.ForceCheckbox`.

```lua
local MyCheckbox = Groupbox:AddCheckbox("MyToggle", {
    Text = "Enable Speed Hack",
    Default = true,
})
```

Same methods: `SetValue`, `SetText`, `SetDisabled`, `SetVisible`, `OnChanged`, `Destroy`.

---

#### A.9.5 Input — `AddInput`

```lua
LeftGroupBox:AddInput("MyTextbox", {
    Default = "My textbox!",
    Numeric = false,               -- only numbers
    Finished = false,              -- only fire on Enter
    ClearTextOnFocus = true,
    Text = "This is a textbox",
    Tooltip = "This is a tooltip",
    Placeholder = "Placeholder text",
    Callback = function(Value) print("[cb] Text updated:", Value) end,
})
```

| Key | Description | Type | Default |
| --- | --- | --- | --- |
| `Text` | Label text | string | `"Input"` (**req**) |
| `Default` | Initial value | string | `""` |
| `Numeric` | Numbers only | boolean | `false` |
| `Finished` | Callback only on Enter | boolean | `false` |
| `ClearTextOnFocus` | Clear on focus | boolean | `true` |
| `ClearTextOnBlur` | Clear on blur (no effect when `Finished = false`) | boolean | `false` |
| `Placeholder` | Placeholder text | string | `""` |
| `AllowEmpty` | Allow empty input | boolean | `true` |
| `EmptyReset` | Fallback when empty and `AllowEmpty = false` | string | `"---"` |
| `MaxLength` | Max characters | number | `nil` |
| `Tooltip` / `DisabledTooltip` | Hover tooltips | string | `nil` |
| `Callback` | Change callback | function | `function() end` |
| `VerifyValue` | Validation; return `true` to accept, else new value becomes `EmptyReset`. Also runs on creation against `Default`. | function | `function() return true end` |
| `Disabled` / `Visible` | State | boolean | `false` / `true` |

Methods: `SetValue(text)`, `SetText(text)`, `SetDisabled(bool)`, `SetVisible(bool)`, `OnChanged(fn)`, `Destroy`.

---

#### A.9.6 Slider — `AddSlider`

```lua
local Slider = Groupbox:AddSlider("Sensitivity", {
    Text = "Sensitivity",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
})
```

| Key | Description | Type | Default |
| --- | --- | --- | --- |
| `Text` | Label (hidden when `Compact`) | string | `"Slider"` (**req**) |
| `Default` | Start value | number | `0` (**req**) |
| `Min` | Minimum | number | `0` (**req**) |
| `Max` | Maximum | number | `100` (**req**) |
| `Rounding` | Decimal precision | number | `0` (**req**) |
| `Prefix` | Text before value | string | `""` |
| `Suffix` | Text after value | string | `""` |
| `Compact` | Hide label, show only value | boolean | `false` |
| `HideMax` | Show only value, not `value/max` | boolean | `false` |
| `FormatDisplayValue` | Custom value formatter | function | `nil` |
| `Callback` | Change callback | function | `function() end` |
| `Tooltip` / `DisabledTooltip` | Hover tooltips | string | `nil` |
| `AllowRightClickInput` | Right-click/double-tap to type a value (can exceed Min/Max) | boolean | `false` |
| `Disabled` / `Visible` | State | boolean | `false` / `true` |

Methods: `SetValue(n)`, `SetText(text)`, `SetMin(n)`, `SetMax(n)`, `SetDisabled(bool)`, `SetVisible(bool)`, `SetPrefix(text)`, `SetSuffix(text)`, `OnChanged(fn)`, `Destroy`.

---

#### A.9.7 Dropdown — `AddDropdown`

```lua
local Dropdown = Groupbox:AddDropdown("MyDropdown", {
    Text = "A dropdown",
    Values = { "This", "is", "a", "dropdown" },
    Default = 1,
    Multi = false,
})
```

| Key | Description | Type | Default |
| --- | --- | --- | --- |
| `Text` | Label text | string | `nil` (**req**) |
| `Values` | Selectable entries (array or dictionary — see below) | table | `{}` (**req**) |
| `Default` | Array index, identity string, or table of identities. For dictionaries use **keys**, not labels. | any | `nil` |
| `Multi` | Multi-select | boolean | `false` |
| `DragSelect` | Drag to select multiple (non-touch + `Multi` only) | boolean | `false` |
| `AllowNull` | Allow no selection | boolean | `false` |
| `Searchable` | Search through labels | boolean | `false` |
| `MaxVisibleDropdownItems` | Max visible rows (caps height; large lists virtualized) | number | `8` |
| `SpecialType` | `"Player"` or `"Team"` data source | string | `nil` |
| `ExcludeLocalPlayer` | Player type: exclude local player | boolean | `false` |
| `EnablePlayerImages` | Player type: show avatar headshots | boolean | `false` |
| `FormatDisplayValue` | Format displayed value | function | `nil` |
| `FormatListValue` | Format values in the list (receives raw `Values` entry; re-called on rebuild, so random formatting is lost) | function | `nil` |
| `DisabledValues` | Identities that can't be selected (dict: keys or labels) | table | `{}` |
| `KeepDisabledValuePosition` | Keep `DisabledValues` in original order instead of moving to end | boolean | `false` |
| `ValueImages` | Map identities → images | table | `{}` |
| `Tooltip` / `DisabledTooltip` | Hover tooltips | string | `nil` |
| `Callback` | Change callback | function | `function() end` |
| `Disabled` / `Visible` | State | boolean | `false` / `true` |

##### Values: List vs Dictionary

```lua
-- List: entry is both identity and display text
Values = { "Sword", "Shield" }
-- selecting "Sword" -> Value == "Sword"

-- Dictionary: key = identity your code gets, value = display label
Values = { item01 = "Excalibur", item05 = "Aegis Shield" }
-- selecting "Excalibur" -> Value == "item01"
```

For multi dropdowns, `Value` is always a map of selected keys to `true` (e.g. `{ item01 = true }`).
`Default`, `SetValue` and `OnChanged` all use the **key**, never the label, for dictionaries.
Sparse numeric tables are treated as arrays (value identity), not dictionaries.

##### Methods

| Method | Description |
| --- | --- |
| `Dropdown:SetValue(v)` | Select a value (`{ [key] = true }` for multi) |
| `Dropdown:SetValues(t)` | Replace all values (removed selections pruned; `Callback` may fire) |
| `Dropdown:AddValues(v)` | Append (array) / merge (dictionary) |
| `Dropdown:SetDisabledValues(t)` | Set disabled values |
| `Dropdown:AddDisabledValues(v)` | Add to disabled list |
| `Dropdown:SetValueImages(t)` | Replace value→image map |
| `Dropdown:AddValueImages(t)` | Merge value→image map |
| `Dropdown:SetText(text)` | Update label |
| `Dropdown:SetDisabled(bool)` | Enable/disable |
| `Dropdown:SetVisible(bool)` | Show/hide |
| `Dropdown:SetDragSelect(bool)` | Toggle drag select |
| `Dropdown:GetActiveValues(countOnly?)` | Selected values; pass `true` for count |
| `Dropdown:OnChanged(fn)` | Add change callback |
| `Dropdown:Destroy()` | Remove from UI |

---

#### A.9.8 Keybind (KeyPicker) — `AddKeyPicker`

Created on any element that returns a reference (`AddToggle`, `AddLabel`, `AddButton`, ...).
Right-clicking the keybind opens a menu to change mode; its `Remove` entry unbinds (sets `None`).

```lua
local Toggle = Groupbox:AddToggle("MyToggle", { Text = "Example Toggle", Default = false })

local Keybind = Toggle:AddKeyPicker("MyKeybind", {
    Text = "Example Keybind",
    Default = "F",
    Mode = "Toggle",
})
```

| Key | Description | Type | Default |
| --- | --- | --- | --- |
| `Text` | Keybind text | string | `"KeyPicker"` |
| `Default` | Initial key | string | `"None"` |
| `DefaultModifiers` | Initial modifiers: `LAlt, RAlt, LCtrl, RCtrl, LShift, RShift, Tab, CapsLock` | table | `{}` |
| `Mode` | `"Toggle"`, `"Hold"`, `"Always"`, `"Press"` | string | `"Toggle"` |
| `SyncToggleState` | Sync with parent toggle state | boolean | `false` |
| `WaitForCallback` | *Press only.* Lock keybind while callbacks run | boolean | `false` |
| `Modes` | Custom list of available modes | table | `{"Always", "Toggle", "Hold"}` |
| `NoUI` | Hide from Keybind Menu & visibility panel | boolean | `false` |
| `Blacklist` | Disallowed keys | table | `{}` |
| `Whitelisted` | Allowed keys (overrides all when non-empty) | table | `{}` |
| `BlacklistModifiers` | Disallowed modifiers | table | `{}` |
| `WhitelistedModifiers` | Allowed modifiers | table | `{}` |
| `Callback` | Fires on state change | function | `function() end` |
| `ChangedCallback` | Fires when binding changes | function | `function() end` |
| `Clicked` | Fires when keybind button clicked | function | `function() end` |

##### Methods

| Method | Description |
| --- | --- |
| `Keybind:SetValue({key, mode, modifiers?})` | Set key and mode |
| `Keybind:GetState()` | Is the keybind active? |
| `Keybind:SetText(text)` | Update text |
| `Keybind:SetMenuVisibility(bool)` | Show/hide in Keybind Menu |
| `Keybind:Update()` | Refresh display |
| `Keybind:OnClick(fn)` | Set click callback |
| `Keybind:OnChanged(fn)` | Set change callback |
| `Keybind:Destroy()` | Remove from UI |

---

#### A.9.9 Color Picker — `AddColorPicker`

Attached to a toggle or label reference.

```lua
local Toggle = Groupbox:AddToggle("MyToggle", { Text = "This is a toggle", Default = true })

local ColorPicker = Toggle:AddColorPicker("ColorPicker1", {
    Default = Color3.new(1, 0, 0),
    Title = "Some color",
    Resizable = true,
})
```

| Key | Description | Type | Default |
| --- | --- | --- | --- |
| `Default` | Initial color | Color3 | `Color3.new(1, 1, 1)` |
| `Title` | Custom title inside picker | string | `nil` |
| `Transparency` | Default transparency (0–1) and enables transparency editing | number | `0` |
| `Resizable` | Picker menu resizable | boolean | `true` |
| `Callback` | Change callback | function | `function() end` |
| `Changed` | Alternate update callback | function | `function() end` |

Methods: `SetValue(hsv, transparency?)`, `SetValueRGB(color, transparency?)`, `OnChanged(fn)`, `Destroy`.

> Color pickers can attach to labels: `AddLabel(...):AddColorPicker(...)` — useful for static UI theming.

---

#### A.9.10 Divider — `AddDivider`

Purely visual; no callbacks.

```lua
Groupbox:AddDivider("This is a divider")

Groupbox:AddDivider({
    Text = "This is a divider",
    MarginTop = 10,
    MarginBottom = 10,
})
```

| Key | Description | Type | Default |
| --- | --- | --- | --- |
| `Text` | Text in the middle | string | `nil` |
| `Margin` | Spacing above and below (overridable) | number | `0` |
| `MarginTop` | Spacing above (overrides `Margin`) | number | `0` |
| `MarginBottom` | Spacing below (overrides `Margin`) | number | `0` |

Methods: `Destroy`.

---

#### A.9.11 Image — `AddImage`

```lua
Groupbox:AddImage("MyImage", {
    Image = "http://www.roblox.com/asset/?id=135666356081915",
    Height = 200,
})
```

| Key | Description | Type | Default |
| --- | --- | --- | --- |
| `Image` | Image URL or asset ID | string | `""` (**req**) |
| `Transparency` | Image transparency (0–1) | number | `0` |
| `BackgroundTransparency` | Background transparency (0–1) | number | `0` |
| `Color` | Color tint | Color3 | `Color3.new(1, 1, 1)` |
| `RectOffset` | Image rect offset | Vector2 | `Vector2.zero` |
| `RectSize` | Image rect size | Vector2 | `Vector2.zero` |
| `ScaleType` | Scale behaviour | Enum.ScaleType | `Enum.ScaleType.Fit` |
| `Height` | Frame height (px) | number | `200` |
| `Callback` | Fires when image changes | function | `function() end` |

Methods: `SetImage`, `SetTransparency`, `SetColor`, `SetRectOffset`, `SetRectSize`, `SetScaleType`, `SetHeight`, `SetVisible`, `Destroy`.

---

#### A.9.12 Video — `AddVideo`

```lua
Groupbox:AddVideo("Trailer", {
    Video = "rbxassetid://1234567890",
    Looped = true,
    Playing = true,
    Volume = 0.4,
    Height = 240,
})
```

| Key | Description | Type | Default |
| --- | --- | --- | --- |
| `Video` | Video asset ID or URL | string | `""` (**req**) |
| `Looped` | Auto-replay | boolean | `false` |
| `Playing` | Start playing | boolean | `false` |
| `Volume` | Playback volume | number | `1` |
| `Height` | Frame height (px) | number | `200` |
| `Visible` | Visible | boolean | `true` |

Methods: `SetVideo`, `SetLooped`, `SetPlaying`, `SetVolume`, `Play()`, `Pause()`, `SetHeight`, `SetVisible`, `Destroy`.

---

#### A.9.13 Viewport — `AddViewport`

Embeds a live 3D `ViewportFrame` with camera control.

```lua
local Viewport = Groupbox:AddViewport("MyViewport", {
    Object = Instance.new("Part"),
    Camera = Instance.new("Camera"),
    Interactive = true,
    AutoFocus = true,
    Height = 200,
})
```

| Key | Description | Type | Default |
| --- | --- | --- | --- |
| `Object` | 3D object to display | Instance | — (**req**) |
| `Clone` | Clone the object for the viewport | boolean | `true` |
| `Camera` | Camera instance | Camera | `Instance.new("Camera")` |
| `Interactive` | Allow zoom/orbit | boolean | `false` |
| `AutoFocus` | Auto-focus camera on object | boolean | `true` |
| `Height` | Frame height (px) | number | `200` |
| `Callback` | Fires when viewport initialises | function | `function() end` |

| Method | Description |
| --- | --- |
| `SetObject(obj)` | Change displayed object |
| `SetCamera(cam)` | Change camera |
| `SetCameraCFrame(cframe)` | Set camera CFrame |
| `GetCameraCFrame()` | Get camera CFrame |
| `Rotate(yaw, pitch?)` | Orbit around pivot (pitch clamped, no flipping) |
| `Zoom(studs)` | Move camera forward (+)/back (−) |
| `LookAt(pos?)` | Point camera at position (defaults to pivot) |
| `SetDistance(studs)` | Move to distance from pivot (>0), keeping direction |
| `GetDistance()` | Distance from pivot (`0` if no object) |
| `SetFieldOfView(deg)` | FOV, clamped 1–120 |
| `SetInteractive(bool)` | Toggle interaction |
| `SetHeight(px)` | Frame height |
| `Focus()` | Focus camera on object |
| `SetVisible(bool)` | Show/hide |
| `Destroy()` | Remove from UI |

---

#### A.9.14 UI Passthrough — `AddUIPassthrough`

Embeds any existing `GuiBase2d` instance into the library layout.

```lua
local Passthrough = Groupbox:AddUIPassthrough("CustomUI", {
    Instance = CustomFrame,
    Height = 180,
})
```

| Key | Description | Type | Default |
| --- | --- | --- | --- |
| `Instance` | GuiBase2d to parent inside the groupbox | GuiBase2d | — (**req**) |
| `Height` | Allocated height | number | `24` |
| `Visible` | Container visibility | boolean | `true` |

Methods: `SetInstance(gui)`, `SetHeight(px)`, `SetVisible(bool)`, `Destroy`.

---

#### A.9.15 Settings — `AddSettings`

Adds a gear button next to an element that opens a floating Groupbox-like panel. Perfect for per-feature sub-options.

Supported on: **Toggles, Checkboxes, Labels** (only when `DoesWrap = false`), **Buttons & Sub Buttons, Inputs, Dropdowns**.
Each element can only have **one** Settings box — repeat calls return the existing one.

```lua
local Toggle = Groupbox:AddToggle("AimbotEnabled", { Text = "Aimbot", Default = false })

local Settings = Toggle:AddSettings({ Width = 220 })

Settings:AddSlider("AimbotFOV", {
    Text = "FOV", Default = 90, Min = 10, Max = 360, Rounding = 0,
})
```

| Key | Description | Type | Default |
| --- | --- | --- | --- |
| `Width` | Fixed width in layout px (defaults to a groupbox column) | number | `nil` |

Methods: `Open()` (no-op while parent disabled), `Close()`, `Toggle()`, `SetWidth(n?)`, `Destroy()`.
Settings inherit all Groupbox `Add*` methods (including `AddDependencyBox`).

---

### A.10. Library Core

#### A.10.1 Lifecycle

```lua
Library:OnUnload(function()
    print("Library was unloaded!")
end)

Library:Unload()   -- disconnect GiveSignal signals, fire OnUnload, destroy tooltips + ScreenGui, set Unloaded = true
```

| Method | Description |
| --- | --- |
| `Library:OnUnload(fn)` | Register unload callback |
| `Library:Unload()` | Full teardown |
| `Library:GiveSignal(connection)` | Track an `RBXScriptConnection` for auto-disconnect on unload |
| `Library:Toggle(state?)` | Toggle main window (wrapper for `Window:Toggle`) |

**Always** register connections with `GiveSignal` so `Unload` cleans them up.

#### A.10.2 Theme & Registry

| Method | Description |
| --- | --- |
| `Library:SetFont(font)` | Change library-wide font (`Enum.Font` or `Font`) |
| `Library:SetNotifySide("Left"\|"Right")` | Notification side |
| `Library:SetDPIScale(percent)` | DPI scale (100 = normal) |
| `Library:AddToRegistry(gui, map)` | Auto-update `gui` properties on theme change |
| `Library:RemoveFromRegistry(gui)` | Stop tracking |
| `Library:UpdateColorsUsingRegistry()` | Re-apply scheme (auto on theme change) |

```lua
Library:AddToRegistry(MyFrame, { BackgroundColor3 = "MainColor" })
```

#### A.10.3 Scheme

`Library.Scheme` holds: `BackgroundColor`, `MainColor`, `AccentColor`, `OutlineColor`, `FontColor`, `Font`, `RedColor`, `DarkColor`, `WhiteColor`.
Theme scheme keys (e.g. `"AccentColor"`) can be used directly as property values in icon/registry APIs.

#### A.10.4 Notable Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `Toggled` | boolean | `false` | Window currently visible |
| `Unloaded` | boolean | `false` | Library unloaded |
| `ForceCheckbox` | boolean | `false` | Render `AddToggle` as checkbox |
| `NotifyOnError` | boolean | `false` | `SafeCallback` shows notification on error |
| `CantDragForced` | boolean | `false` | Window cannot be dragged |
| `IsMobile` | boolean | auto | Device is mobile (**do not modify**) |
| `Scheme` | Scheme | default theme | Active color scheme |
| `ShowCustomCursor` | boolean | — | Enable Obsidian cursor |
| `ToggleKeybind` | KeyPicker | — | Assign a KeyPicker to toggle the window |
| `KeybindFrame` / `KeybindMenu` | — | — | Created by `CreateWindow` |
| `Options` | table | — | All options by ID |
| `Toggles` | table | — | Toggle options by ID |
| `Labels` | table | — | Label options by ID |
| `ImageManager` | table | — | Custom asset icon manager |

---

### A.11. Loading Screen

A modal overlay with progress bar and optional sidebar, for multi-stage initialisation.

```lua
local Loading = Library:CreateLoading({
    Title = "mspaint",
    Icon = 95816097006870,
    TotalSteps = 4,
})

Loading:SetMessage("Initializing...")
Loading:SetDescription("Waiting for game to load...")
task.wait(1)

Loading:SetCurrentStep(1)
Loading:SetDescription("Loading configuration...")
task.wait(1)

Loading:SetCurrentStep(2)
Loading:ShowSidebarPage(true)
Loading.Sidebar:AddLabel("User: " .. game.Players.LocalPlayer.Name)
Loading.Sidebar:AddLabel("Version: v1.0.0")
task.wait(1)

Loading:SetCurrentStep(3)
Loading:SetDescription("Ready to start!")
task.wait(1)

Loading:SetCurrentStep(4)
Loading:Continue()   -- destroys loader, opens the main window
```

#### A.11.1 Configuration

| Key | Description | Type | Default |
| --- | --- | --- | --- |
| `Title` | Title at top | string | `"mspaint"` |
| `Icon` | Top-bar icon | string/ID | `95816097006870` |
| `IconSize` | Top-bar icon size | UDim2 | `UDim2.fromOffset(30, 30)` |
| `LoadingIcon` | Rotating center asset | string/ID | `"rbxassetid://97544096941083"` |
| `LoadingIconTweenTime` | Rotation tween time | number | `1` |
| `LoadingIconColor` | Loading icon color | Color3 | White if custom icon; AccentColor if default |
| `CurrentStep` | Initial progress | number | `0` |
| `TotalSteps` | Max progress | number | `10` |
| `ShowSidebar` | Open sidebar initially | boolean | `false` |
| `WindowWidth` | Window width (ignored when sidebar open → ContentWidth + SidebarWidth) | number | `450` |
| `WindowHeight` | Window height | number | `275` |
| `AutoResizeHeight` | Auto-size height to content | boolean | `false` |
| `AlwaysOnTop` | Above core blur (executor only) | boolean | `true` |
| `ContentWidth` | Main content width (sidebar open) | number | `450` |
| `SidebarWidth` | Sidebar width | number | `250` |

#### A.11.2 Methods

| Method | Description |
| --- | --- |
| `SetMessage(text)` | Primary status message |
| `SetDescription(text)` | Secondary description |
| `SetCurrentStep(n)` | Update progress bar + counter |
| `SetTotalSteps(n)` | Update total steps |
| `SetLoadingIcon(icon)` | Switch rotating icon (Lucide or asset) |
| `SetLoadingIconTweenTime(n)` | Rotation tween time (`0` stops rotation) |
| `SetLoadingIconColor(color)` | Update icon color |
| `ShowSidebarPage(bool)` | Toggle sidebar |
| `ShowErrorPage(bool)` | Switch to error view |
| `SetErrorMessage(text)` | Error screen text |
| `SetErrorButtons(map)` | Replace error buttons (same layout as Dialog `FooterButtons`) |
| `Destroy()` | Close loader; restores window visibility if `CreateWindow` already ran |
| `Continue()` | Alias for `Destroy()` |

```lua
Loading:SetErrorButtons({
    Retry = {
        Title = "Retry Connection",
        Variant = "Primary",
        Callback = function() -- logic end
    }
})
```

#### A.11.3 Sidebar

`Loading.Sidebar` behaves like a **groupbox** — every UI element works there.

```lua
Loading.Sidebar:AddLabel("Version: 1.2.0")
Loading.Sidebar:AddButton("Print Hello World", function() print("Hello World") end)
```

---

### A.12. Notifications

```lua
Library:Notify("Hello world!", 4)
```

#### A.12.1 Positional Arguments

| Arg | Description | Type | Default |
| --- | --- | --- | --- |
| 1 | Description text | string | `"nil"` |
| 2 | Duration in seconds | number | `4` |
| 3 | SoundId to play | number | `nil` |
| 4 | Sound volume | number | `3` |

#### A.12.2 Table Configuration

| Key | Description | Type | Default |
| --- | --- | --- | --- |
| `Title` | Notification title | string | `"No Title"` |
| `TitleColor` | Title color | Color3/string | `nil` |
| `Description` | Description text | string | `"No Description"` (**req**) |
| `DescriptionColor` | Description color | Color3/string | `nil` |
| `Time` | Duration in seconds | number | `5` |
| `Steps` | Total step count | number | `0` |
| `Persist` | Stay until destroyed | boolean | `false` |
| `SoundId` | Sound on show | number | `nil` |
| `Icon` | Inline Lucide icon or image | string | `nil` |
| `BigIcon` | Legacy 24×24 separated image | string | `nil` |
| `IconColor` | Legacy image tint | Color3/string | `nil` |
| `Volume` | Sound volume (when `SoundId` set) | number | `3` |

#### A.12.3 Examples

```lua
-- simple
Library:Notify({ Title = "mspaint", Description = "Hello world!", Time = 4 })

-- icon
Library:Notify({
    Title = "Icon Notification",
    Description = "Has a neat little icon beside the text.",
    Icon = "info",
    Time = 4,
})

-- big icon
Library:Notify({
    Title = "Big Icon Notification",
    Description = "Uses the legacy 24x24 separated image layout.",
    BigIcon = "rbxassetid://10204738596",
    IconColor = Color3.new(0, 1, 0),
    Time = 4,
})

-- persistent + update
local Notification = Library:Notify({
    Title = "mspaint",
    Description = "Waiting for next match...",
    Persist = true,
})

game.Players.LocalPlayer:GetAttributeChangedSignal("Playing"):Wait()

Notification:ChangeTitle("mspaint - Match Starting")
Notification:ChangeDescription("Waiting for match to finish loading...")

workspace.Map:GetAttributeChangedSignal("MatchLoaded"):Wait()
Notification:Destroy()

-- progress
local Progress = Library:Notify({ Title = "mspaint", Description = "Loading...", Steps = 10 })
for i = 1, 10 do
    Progress:ChangeStep(i)
    task.wait(0.1)
end
Progress:Destroy()
```

#### A.12.4 Methods

| Method | Description |
| --- | --- |
| `Notification:ChangeTitle(text)` | Update title in place |
| `Notification:ChangeDescription(text)` | Update description in place |
| `Notification:ChangeStep(n)` | Advance/rewind step progress |
| `Notification:Destroy()` | Dismiss immediately |

---

### A.13. Dialogs

Modal overlays that blur the background and demand attention. **Dialogs inherit all Groupbox methods** (`AddToggle`, `AddInput`, `AddSlider`, `AddDropdown`, ...), so you can put controls directly inside them.

```lua
local Dialog
Dialog = Window:AddDialog("DialogueIdx", {
    Title = "Test Dialog",
    Description = "This is a test dialog. Please confirm or cancel.",
    AutoDismiss = true,
    OutsideClickDismiss = true,
    FooterButtons = {
        Cancel = {
            Title = "Cancel",
            Variant = "Ghost",
            Order = 1,
            Callback = function() print("Cancelled the dialog.") end,
        },
        Secondary = {
            Title = "Secondary",
            Variant = "Secondary",
            Order = 2,
            Callback = function() print("Secondary action.") end,
        },
        Delete = {
            Title = "Delete",
            Variant = "Destructive",
            Order = 3,
            Callback = function() print("Deleted the asset.") end,
        },
        Confirm = {
            Title = "Confirm",
            Variant = "Primary",
            WaitTime = 3,  -- 3 second minimum wait
            Order = 4,
            Callback = function(self) print("Confirmed the dialog.") end,
        },
    },
})

Dialog:AddToggle("DisableSecondary", {
    Text = "Disable Secondary Button",
    Default = false,
    Callback = function(value) Dialog:SetButtonDisabled("Secondary", value) end,
})

Dialog:AddInput("InputTest", {
    Text = "Type something here:",
    Callback = function(value) print("Typed:", value) end,
})

Dialog:AddToggle("SwapDeleteOrder", {
    Text = "Send Delete to Right",
    Default = false,
    Callback = function(value) Dialog:SetButtonOrder("Delete", value and 5 or 3) end,
})
```

#### A.13.1 Configuration

| Key | Description | Type | Default |
| --- | --- | --- | --- |
| `Title` | Dialog title | string | `"No Title"` |
| `Description` | Dialog description | string | `"No Description"` |
| `AutoDismiss` | Close when a footer button is pressed | boolean | `true` |
| `OutsideClickDismiss` | Close on background click | boolean | `false` |
| `FooterButtons` | Map of button id → `DialogButtonInfo` | table | `{}` |
| `Icon` | Dialog icon | string | `nil` |
| `TitleColor` | Title color | Color3 | theme `FontColor` |
| `DescriptionColor` | Description color | Color3 | theme `FontColor` +20% transparency |

#### A.13.2 DialogButtonInfo

| Key | Description |
| --- | --- |
| `Title` | Button text |
| `Variant` | `"Primary"`, `"Secondary"`, `"Destructive"`, `"Ghost"` |
| `WaitTime` | Minimum seconds before clickable (animated progress bar blocks interaction) |
| `Order` | Layout order |
| `Callback` | Fires on click, receives `self` |

#### A.13.3 Unique Dialog Methods

| Method | Description |
| --- | --- |
| `Dialog:SetTitle(text)` | Update title |
| `Dialog:SetDescription(text)` | Update description |
| `Dialog:AddFooterButton(id, info)` | Inject a footer button |
| `Dialog:RemoveFooterButton(id)` | Remove a footer button |
| `Dialog:SetButtonDisabled(id, bool)` | Enable/disable a button |
| `Dialog:SetButtonOrder(id, order)` | Change a button's layout order |
| `Dialog:Dismiss()` | Close and destroy the dialog |

---

### A.14. Overlays

#### A.14.1 Draggable Labels

Compact draggable text overlays (FPS, ping, server info). Successor to the deprecated Watermark.

```lua
local DraggableLabel = Library:AddDraggableLabel("Obsidian demo")           -- text only
-- (text, icon?, iconSide?)  iconSide: "Left" | "Right" (default "Left")
```

Methods: `SetText(text)`, `SetVisible(bool)`, `Destroy()`.

```lua
local DraggableLabel = Library:AddDraggableLabel("Obsidian demo")
DraggableLabel:SetVisible(true)

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local Connection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end
    DraggableLabel:SetText(('Obsidian demo | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end)
```

#### A.14.2 Draggable Buttons

Floating buttons that fire a callback, passing themselves as the first argument.

```lua
local DraggableButton = Library:AddDraggableButton("Click Me", function(self)
    print("Button was clicked!")
end)
-- (text, callback, excludeDPIScaling?, icon?, iconSide?)
```

Methods: `SetText(text)` (auto-resizes), `Destroy()`.

#### A.14.3 Draggable Menus

Floating panel with a title bar and a `UIListLayout` container.

```lua
local Holder, Container = Library:AddDraggableMenu("My Menu")
-- Holder    => outer draggable frame
-- Container => inner frame with UIListLayout
```

Methods: `Holder:Destroy()`.

```lua
local Holder, Container = Library:AddDraggableMenu("Stats Panel")

local Label = Instance.new("TextLabel")
Label.Text = "Hello from the menu!"
Label.Size = UDim2.new(0, 100, 0, 24)
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.new(1, 1, 1)
Label.ZIndex = 11
Label.Parent = Container
```

> **ZIndex gotcha:** Draggable Menus render at **ZIndex 10**. Children must have **ZIndex ≥ 10** or they'll be hidden behind the menu frame.

---

### A.15. Keybind Menu

A floating overlay listing every registered KeyPicker with its state. In `Toggle` mode it renders tap-friendly buttons for mobile parity.

`Library.KeybindFrame` and `Library.KeybindMenu` are created by `Library:CreateWindow()`.

#### A.15.1 Enabling

Hidden by default; set `Visible = true`:

```lua
Library.KeybindFrame.Visible = true
```

#### A.15.2 Toggle Checkboxes

```lua
Library.ShowToggleFrameInKeybinds = true   -- default true
```

| Value | Behaviour |
| --- | --- |
| `true` | Toggle-mode keybinds show a clickable checkbox |
| `false` | Only name and key are shown |

> `Press`-mode KeyPickers appear as buttons; clicking fires the KeyPicker like the key press.

#### A.15.3 Collapse

| Method | Description |
| --- | --- |
| `Library.KeybindMenu:SetCollapsed(bool)` | Collapse/expand the list |
| `Library.KeybindMenu:ToggleCollapsed()` | Toggle collapsed |

#### A.15.4 Visibility Settings

Keybinds with `NoUI = true` never appear here. Visibility control is **off by default**; enabling it shows a settings icon that opens a "Visible Keybinds" panel with a checkbox per keybind (calls `KeyPicker:SetMenuVisibility`).

| Method | Description |
| --- | --- |
| `Library.KeybindMenu:SetVisibilityControl(bool)` | Enable settings icon + panel |
| `Library.KeybindMenu:SetSettingsOpen(bool)` | Open/close the panel |
| `Library.KeybindMenu:ToggleSettings()` | Toggle panel |
| `Library.KeybindMenu:RefreshSettings()` | Refresh panel |

#### A.15.5 Example (UI toggles)

```lua
MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "Open Keybind Menu",
    Callback = function(Value)
        Library.KeybindFrame.Visible = Value
    end,
})

MenuGroup:AddToggle("KeybindMenuVisibilityControl", {
    Default = false,
    Text = "Keybind Menu Visibility",
    Callback = function(Value)
        Library.KeybindMenu:SetVisibilityControl(Value)
    end,
})
```

---

### A.16. Utility & Helpers

#### A.16.1 Custom Cursor

```lua
Library.ShowCustomCursor = true
```

Two layers: a crosshair and an optional icon, controlled via `Library.Cursor`.

| Method | Description |
| --- | --- |
| `Library.Cursor:ChangeCrossColor(color)` | Inner crosshair color |
| `Library.Cursor:ResetCross()` | Reset crosshair to default white |
| `Library.Cursor:ChangeIcon(icon)` | Replace crosshair with icon (Lucide name, asset ID, or URL; `""` = reset) |
| `Library.Cursor:ChangeIconColor(color)` | Icon tint |
| `Library.Cursor:ChangeIconSize(udim2)` | Icon size |
| `Library.Cursor:ResetIcon()` | Hide icon, restore crosshair, reset color/size |
| `Library.Cursor:ResetCursor()` | Reset both |

```lua
Library.Cursor:ChangeCrossColor(Color3.fromRGB(255, 80, 80))
Library.Cursor:ResetCross()

Library.Cursor:ChangeIcon("crosshair")
Library.Cursor:ChangeIconColor(Color3.fromRGB(80, 255, 120))
Library.Cursor:ChangeIconSize(UDim2.fromOffset(32, 32))
Library.Cursor:ResetIcon()

Library.Cursor:ResetCursor()
```

#### A.16.2 Icons

Obsidian uses [Molto](https://github.com/notpoiu/Molto). Swap providers (must happen **before creating UI**):

```lua
Library:SetIconModule(Icons)
```

Icons may be **font icons** (`FontFace` + `Text` → TextLabel/TextButton) or **image icons** (`Url`, `ImageRectOffset`, `ImageRectSize` → ImageLabel/ImageButton). Use `CreateIcon`/`ApplyIcon` so you don't handle both.

| Method | Description |
| --- | --- |
| `Library:GetIcon(name)` | Icon table for a Lucide name, or `nil` |
| `Library:GetCustomIcon(nameOrIdOrUrl)` | Same, but also accepts asset IDs / URLs |
| `Library:CreateIcon(icon, props?, asButton?)` | Create a label/button from an icon table |
| `Library:ApplyIcon(instance, icon)` | Apply icon to existing instance; **returns the (possibly replaced) instance** |

```lua
local Icon = Library:GetCustomIcon("settings")

local IconLabel = Library:CreateIcon(Icon, {
    ImageColor3 = "AccentColor",   -- scheme keys work as values
    ImageTransparency = 0.5,
    Size = UDim2.fromOffset(16, 16),
    Parent = MyFrame,
})

IconLabel = Library:ApplyIcon(IconLabel, Library:GetCustomIcon("house"))
```

> **Important:** if the icon type doesn't match the instance class (e.g. font icon onto an `ImageLabel`), `ApplyIcon` replaces the instance with a new one preserving shared properties — so **always use the returned instance**.

`ImageColor3`/`ImageTransparency` are auto-mapped to `TextColor3`/`TextTransparency` for font icons.

##### Required icon names

A custom icon module must provide at least:
`check`, `chevron-up`, `move-diagonal-2`, `key`, `search`, `move`, `square-arrow-down-left`, `x`, `settings`.

##### Custom icon module contract

```lua
type Icon = {
    Url: string,
    Id: number,
    IconName: string,
    ImageRectOffset: Vector2,
    ImageRectSize: Vector2,
    -- Font icons only
    FontFace: Font?,
    Text: string?,
}

type IconModule = {
    Icons: { string },
    GetAsset: (Name: string) -> Icon?,
}
```

#### A.16.3 Custom Asset Icons (ImageManager)

```lua
local ImageManager = Library.ImageManager
```

> Requires `FileSystem` + `getcustomasset`. Without them it falls back to the provided Roblox asset ID. If a saved image fails to load, it does **not** fall back.

| Method | Description |
| --- | --- |
| `ImageManager.AddAsset(name, assetId, url, forceRedownload?)` | Register asset (auto-downloads) |
| `ImageManager.GetAsset(name)` | Get resolved asset ID |
| `ImageManager.DownloadAsset(name, forceRedownload?)` | Download/redownload image to workspace |

```lua
ImageManager.AddAsset("mspaint_logo", 95816097006870, "https://www.mspaint.cc/icon.png")
local AssetID = ImageManager.GetAsset("mspaint_logo")
```

#### A.16.4 Menu Keybind

Bind a KeyPicker to the main window toggle:

```lua
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI = true,
    Text = "Menu keybind",
})

Library.ToggleKeybind = Options.MenuKeybind
```

#### A.16.5 Color Helpers

| Method | Description |
| --- | --- |
| `Library:GetBetterColor(color, amount)` | Adjust brightness by amount |
| `Library:GetLighterColor(color)` | Slightly lighter |
| `Library:GetDarkerColor(color)` | Slightly darker |

#### A.16.6 Misc Helpers

| Method | Description |
| --- | --- |
| `Library:SafeCallback(fn, ...)` | Error-handled call; notifies if `NotifyOnError` |
| `Library:GetTextBounds(text, font, size, maxWidth?)` | Returns `(width, height)` of text |

```lua
local width, height = Library:GetTextBounds("Hello", Library.Scheme.Font, 14, 200)
```

---

### A.17. Addon: ThemeManager

Ships built-in color schemes plus utilities to create, persist and reuse custom themes.

#### A.17.1 Quick Start

```lua
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("MyScriptHub")          -- optional custom folder

local Tab = Window:AddTab("UI Settings", "settings")
ThemeManager:ApplyToTab(Tab)                   -- creates color pickers, theme lists, buttons
ThemeManager:LoadDefault()                     -- apply the default theme
```

`ThemeManager.BuiltInThemes` includes Default, BBot, Fatality, Nord, Dracula, Catppuccin and more.

#### A.17.2 Methods

| Method | Description |
| --- | --- |
| `ThemeManager:SetLibrary(lib)` | Register library instance |
| `ThemeManager:SetFolder(folder)` | Base folder for theme JSON (default `"ObsidianLibSettings"`) |
| `ThemeManager:ApplyTheme(name)` | Apply built-in or custom theme |
| `ThemeManager:ThemeUpdate()` | Push picker values into library scheme (auto on change) |
| `ThemeManager:GetCustomTheme(name)` | Load custom theme JSON → `table?` |
| `ThemeManager:LoadDefault()` | Apply saved default theme |
| `ThemeManager:SaveDefault(name)` | Persist default theme name |
| `ThemeManager:SetDefaultTheme(theme)` | Replace built-in `Default` (**before** `ApplyToTab`) |
| `ThemeManager:SaveCustomTheme(name)` | Serialize to `<folder>/themes/<name>.json` |
| `ThemeManager:Delete(name)` | Delete custom theme → `(success, err?)` |
| `ThemeManager:ReloadCustomThemes()` | Rescan directory → `{ string }` |
| `ThemeManager:CreateThemeManager(groupbox)` | Build controls inside a groupbox |
| `ThemeManager:CreateGroupBox(tab, icon)` | Create standard "Themes" groupbox, returns it |
| `ThemeManager:ApplyToTab(tab, icon?)` | Create groupbox + install UI |
| `ThemeManager:ApplyToGroupbox(groupbox)` | Install UI into existing groupbox |

##### `SetDefaultTheme` keys

`FontColor`, `MainColor`, `AccentColor`, `BackgroundColor`, `OutlineColor`, `FontFace`, `BackgroundImage`.

---

### A.18. Addon: SaveManager

Save, load, delete and autoload configurations.

#### A.18.1 Quick Start

```lua
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Tabs = {
    Main = Window:AddTab("Main", "user"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()                 -- don't save theme settings
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })   -- manual ignore list
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("Lobby")                 -- optional per-place configs
-- path becomes: MyScriptHub/specific-game/settings/Lobby
SaveManager:BuildConfigSection(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
```

#### A.18.2 Methods

| Method | Description |
| --- | --- |
| `SaveManager:SetLibrary(lib)` | Register library |
| `SaveManager:SetFolder(folder)` | Config root folder |
| `SaveManager:SetSubFolder(subfolder)` | Optional per-place subfolder |
| `SaveManager:SetIgnoreIndexes(indexes)` | Option IDs excluded from saves |
| `SaveManager:IgnoreThemeSettings()` | Ignore default theme-related indexes |
| `SaveManager:Save(name)` | Serialize state → `(success, err?)` |
| `SaveManager:Load(name)` | Applite config → `(success, err?)` |
| `SaveManager:Delete(name)` | Remove config → `(success, err?)` |
| `SaveManager:RefreshConfigList()` | Scan folder → `{ string }` |
| `SaveManager:GetAutoloadConfig()` | Autoload config name or `"none"` |
| `SaveManager:LoadAutoloadConfig()` | Load the marked config |
| `SaveManager:SaveAutoloadConfig(name)` | Mark config for autoload → `(success, err?)` |
| `SaveManager:DeleteAutoLoadConfig()` | Clear autoload marker → `(success, err?)` |
| `SaveManager:BuildConfigSection(tab, icon?)` | Build config UI (also auto-ignores its own controls) |
| `SaveManager:SetLoadingOrder(enabled, order)` | Custom element load order |

```lua
SaveManager:SetLoadingOrder(true, {
    "Dropdown", "ColorPicker", "KeyPicker", "Slider", "Input", "Toggle",
})
```

> Element types available for ordering: `Toggle`, `Slider`, `Dropdown`, `ColorPicker`, `KeyPicker`, `Input`.

---

### A.19. Options Registry & Callback Pattern

Every created element is registered in a global options table, keyed by its **ID** (first argument).

```lua
local Options = Library.Options
local Toggles = Library.Toggles

Groupbox:AddToggle("MyToggle", { Text = "Enable Speed Hack", Default = true })

-- read the current value
if Toggles.MyToggle.Value then ... end
print(Options.MyToggle.Value)

-- attach a callback later (recommended style)
Toggles.MyToggle:OnChanged(function(state)
    print("Toggle state changed to " .. tostring(state))
end)
```

Notes:

- `Library.Options` — all options by ID.
- `Library.Toggles` — toggle/checkbox options by ID.
- `Library.Labels` — label options by ID.
- State lives on `.Value` (toggles/inputs/dropdowns/sliders), plus `.Transparency` for color pickers and `.Modifiers` for keypicks.
- **Config-creation order matters for dependencies**: create the parent option first, then the dependency box and its children, then call `SetupDependencies` after all elements exist.
- The docs recommend `:OnChanged()` over the inline `Callback` for anything beyond trivial use.

---

### A.20. Deprecated APIs

These still work but should be avoided:

| Deprecated | Replacement |
| --- | --- |
| `Tab:AddLeftGroupbox(name, icon, ...)` | `Tab:AddGroupbox({ Side = "Left", ... })` |
| `Tab:AddRightGroupbox(name, icon, ...)` | `Tab:AddGroupbox({ Side = "Right", ... })` |
| `Tab:AddLeftTabbox(name)` | `Tab:AddTabbox({ Side = "Left", ... })` |
| `Tab:AddRightTabbox(name)` | `Tab:AddTabbox({ Side = "Right", ... })` |
| `Library:SetWatermark(text)` / `SetWatermarkVisibility(bool)` | `Library:AddDraggableLabel(...)` |
| `Library:ChangeCursorIcon` / `ChangeCursorIconSize` / `ResetCursorIcon` / `ChangeCursorCrossColor` / `ResetCursorCross` / `ChangeCursorIconColor` | `Library.Cursor:*` methods |
| `Library:ApplyLucideIcon(instance, icon, rotation?)` | `Library:CreateIcon(...)` / `Library:ApplyIcon(...)` |

---

### A.21. Gotchas & Best Practices

1. **`SetIconModule` before any UI creation** — required or icons break (especially in Studio).
2. **`Library.KeybindFrame` / `Library.KeybindMenu` only exist after `CreateWindow()`**.
3. **Dictionary dropdowns**: `Default`, `SetValue`, and `OnChanged` all use **keys**, never display labels. Multi-select `Value` is a map `{key = true}`.
4. **Draggable Menus use ZIndex 10** — children need ZIndex ≥ 10.
5. **`ApplyIcon` may replace the instance** — always reassign from the return value.
6. **`AddKeyBox` does no validation** — you must implement the key check.
7. **`WaitTime` on dialog buttons** renders an animated progress bar and blocks clicks until it expires — useful for "dangerous" confirmations.
8. **`SetDefaultTheme` must be called before `ApplyToTab`** or the built-in Default is already rendered.
9. **`ImageManager` needs `FileSystem` + `getcustomasset`**; no fallback if a cached image is corrupt.
10. **`Settings:Open()` is a no-op while the parent element is disabled.**
11. **One Settings box per element** — repeat `AddSettings` calls return the existing one.
12. **Always clean up connections** with `Library:GiveSignal(conn)` so `Library:Unload()` disconnects them.
13. **`Library.IsMobile` is auto-detected — don't write to it.**
14. **`FormatListValue` is re-invoked on every list rebuild** — randomized formatting will not persist.
15. **`MaxVisibleDropdownItems` caps height**; large lists are virtualized with a fixed row pool, so instance counts stay roughly constant.
16. **`AlwaysOnTop` is executor-only** — no effect in Studio or web.
17. **`ThemeManager` in Studio cannot save themes** (no filesystem).
18. **`SaveManager` is unavailable in Studio.**

---

### A.22. Quick-Start Template

Complete working skeleton with both addons:

```lua
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = "My Script",
    Footer = "version: 1.0.0",
    Icon = 95816097006870,
    NotifySide = "Right",
    Animations = { ToggleWindow = true, TabSwitch = true },
})

local Tabs = {
    Main = Window:AddTab("Main", "user"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

-- === Main tab ===
local Combat = Tabs.Main:AddGroupbox({ Side = "Left", Name = "Combat", IconName = "sword" })

Combat:AddToggle("AimbotEnabled", { Text = "Aimbot", Default = false })

local AimbotSettings = Combat:AddDependencyBox()
AimbotSettings:AddSlider("AimbotFOV", {
    Text = "FOV", Default = 90, Min = 10, Max = 360, Rounding = 0, Suffix = "°",
})
AimbotSettings:AddKeyPicker("AimbotKey", {
    Text = "Aimbot Bind", Default = "Q", Mode = "Toggle",
})
AimbotSettings:SetupDependencies({ { Library.Toggles.AimbotEnabled, true } })

local Visuals = Tabs.Main:AddGroupbox({ Side = "Right", Name = "Visuals", IconName = "eye" })

local ESPToggle = Visuals:AddToggle("ESPEnabled", { Text = "Player ESP", Default = true })
ESPToggle:AddColorPicker("ESPColor", {
    Default = Color3.fromRGB(255, 80, 80),
    Title = "ESP Color",
    Transparency = 0.2,
})

Visuals:AddDropdown("ESPStyle", {
    Text = "Style",
    Values = { Box = "Box", Name = "Name", Tracer = "Tracer" },  -- key = identity, value = label
    Default = "Box",
    Multi = true,
})

Visuals:AddDivider("Misc")

Visuals:AddButton({
    Text = "Save Position",
    Icon = "save",
    Func = function()
        Library:Notify({ Title = "Saved", Description = "Position stored.", Icon = "check", Time = 3 })
    end,
})

-- callbacks (register after all elements exist)
Library.Toggles.AimbotEnabled:OnChanged(function(state)
    print("Aimbot:", state)
end)

-- === UI Settings tab ===
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("MyScriptHub")
ThemeManager:ApplyToTab(Tabs["UI Settings"])
ThemeManager:LoadDefault()

SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
SaveManager:SetFolder("MyScriptHub/my-game")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

-- === Menu keybind + watermark ===
Tabs["UI Settings"]:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift", NoUI = true, Text = "Menu keybind",
})
Library.ToggleKeybind = Library.Options.MenuKeybind

local Watermark = Library:AddDraggableLabel("My Script v1.0.0")

Library:Notify({ Title = "My Script", Description = "Loaded successfully.", Icon = "check", Time = 4 })
```

---

*Reference compiled from the complete Obsidian documentation (37 pages). For the latest and any changes since this was written, consult <https://docs.mspaint.cc/obsidian> and the [example script](https://github.com/deividcomsono/Obsidian/blob/main/Example.lua).*

