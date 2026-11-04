<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./README/vapelogo-white.png">
    <source media="(prefers-color-scheme: light)" srcset="./README/vapelogo-dark.png">
    <img alt="inhaler logo" src="./README/vapelogo-dark.png">
  </picture>
</p>
<h2 align="center">
  Inhaler V4, rebuilt on the Obsidian interface.
  <br/>
  Same modules, same whitelist, same backend — a different GUI.
</h2>

This repository is the **Obsidian-UI build** of [Inhaler V4](https://github.com/Night5449791/InhalerV4ForRoblox).
In order to compile this build, ask AI Agent to read AGENTS.md
The game modules, libraries and profile format are unchanged; the entire click GUI is
re-implemented on top of [Obsidian](https://github.com/deividcomsono/Obsidian) instead of
Vape's own widget library.

**This is a build output, not a source tree.** Nothing here is written by hand — every
file is produced from [`InhalerV4ForRoblox/src/`](https://github.com/Night5449791/InhalerV4ForRoblox).
Editing a file here is erased by the next build; fix the source instead.

## License
- **[Original Project Vape V4](https://github.com/7GrandDadPGN/VapeV4ForRoblox)** is licensed under [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/)
- **[Inhaler V4](https://github.com/Night5449791/InhalerV4ForRoblox)**, the fork this is built from, is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
- **This build** inherits [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/): use, modify and redistribute it freely, including commercially, as long as you give appropriate credit to this repository, to Inhaler V4 and to the original Vape V4 project.
- **[Obsidian](https://github.com/deividcomsono/Obsidian)** by [deivid](https://github.com/deividcomsono) provides the UI library and is vendored into the build.

## Contacts
[My Discord](https://discord.com/users/1448308188439904309)
<br/>
[7GrandDad's Community Discord](https://discord.gg/VZEQJxMSnG)
<br/>
[7GrandDad's YouTube](https://youtube.com/c/7GrandDadVape)

## Usage
1. Download the specific scripting utility of your choice.
2. Execute the provided loadstring below.
```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/Night5449791/InhalerObsidianCompiled/main/loader.lua", true))()
```
3. If it still loads a previous build try this loadstring instead.
```luau
pcall(function()
    delfile("newvape/main.lua")
end)
pcall(function()
    delfolder("newvape/libraries")
end)
pcall(function()
    delfolder("newvape/games")
end)
pcall(function()
    delfolder("newvape/guis")
end)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Night5449791/InhalerObsidianCompiled/main/loader.lua", true))()
```

> The Vape build and this build share the same `newvape/` folder. Running one after the
> other without clearing it mixes the two caches, so use the reset snippet above when
> switching.

## Contents

| Path | What it is |
|---|---|
| `loader.lua` | cache-aware bootstrap; scrapes the commit sha and downloads the rest |
| `main.lua` | waits for the game, uninjects a previous load, then loads the GUI and games |
| `libraries/*.lua` | `entity`, `hash`, `prediction`, `vm`, `drawing`, `webhook`, `backend` |
| `guis/new.lua` | the Obsidian GUI, one chunk with the library inlined |
| `games/universal.lua` | modules loaded into every game |
| `games/<PlaceId>.lua` | one chunk per supported game |

Every downloaded `.lua` carries the watermark line that lets the loader delete stale
cached files after an update.

## What changed from the Vape build

| | Vape build | **this build** |
|---|---|---|
| GUI | Vape's own `components/*` | **Obsidian** window, tabs and groupboxes |
| UI library | Vape's widget code | **Obsidian** + its ThemeManager addon |
| game modules | unchanged | **unchanged** |
| libraries | unchanged | **unchanged** |
| profile format | `{Modules, Categories, Legit, v = 1}` | **unchanged** — existing profiles still load |

A category becomes a tab, a module becomes a toggle, and that module's options live in
a dependency box underneath it, shown only while the module is on.

Two approximations, because Obsidian has no counterpart:

- **Two-slider options** render as two sliders (`X Min` / `X Max`); there is no
  dual-handle control. The saved `{ValueMin, ValueMax}` shape is preserved.
- **Colour sliders** use one colour picker. Vape's rainbow animation does not animate,
  but `Rainbow` stays in the saved shape so profiles round-trip.

## Possible Issues
Half of the time its usually the scripting utility at fault, please make sure the utility meets certain quality standards such as.
1. Supporting file functions & the debug library.
2. Not implementing lua generated / half baked versions of such functions resulting in unintended behavior.
3. Maintaining the same behavior across all usages of said functions.
### User Issues
If its not the supposed utility at fault, please try some troubleshooting steps.
1. Deleting the newvape folder (WITH THE GAME CLOSED).
2. Making sure you have connection to [this build's loader.](https://raw.githubusercontent.com/Night5449791/InhalerObsidianCompiled/refs/heads/main/loader.lua)
3. Ensuring no external script is conflicting.
4. Report the issue by using

## Developers & Credits
[Nighthere123](https://github.com/Night5449791) - discord nightdiamond700 - Fork owner
<br/>
[deivid](https://github.com/deividcomsono) - Obsidian UI library
<br/>
[7GrandDad](https://github.com/7GrandDadPGN) - Original Lead maintainer of Vape V4 - vaperoblox on Discord
<br/>
[rce-incorporated](https://github.com/rce-incorporated/Fiu) - Luau bytecode disassembly with modifications
<br/>
[Egor Skriptunoff, boatbomber, and howmanysmall](https://devforum.roblox.com/t/open-source-hashlib/416732/1) - HashLibrary for Luau
<br/>
[Vernumerator](https://devforum.roblox.com/t/projectile-ballistics-including-gravity-and-motion/1842434) - Projectile prediction for Roblox
