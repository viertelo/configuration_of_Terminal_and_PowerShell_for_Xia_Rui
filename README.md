# Windows Terminal & Multi-Shell Modernization

**English** · [简体中文](README.zh-CN.md) · [日本語](README.ja.md)

Configure PowerShell 7, Windows PowerShell 5.1, CMD, NuShell, and MSYS2 with prompts, fonts, tool aliases, and startup banners, with configuration snapshots before installation and dedicated restore commands.

## Preview

![PowerShell in Windows Terminal with a random theme, Fastfetch ASCII art and system information, and a Chinese command reference panel](assets/Ashampoo_Snap_12h54m57s.png)

This screenshot shows an actual local PowerShell 7 setup with an Oh My Posh theme, Fastfetch ASCII art, hardware information, and a Chinese command reference panel. The wallpaper is a local customization and is not included in the repository. Versions, hardware, tool availability, and startup timings reflect that machine at the time of capture. [View full-size image](assets/Ashampoo_Snap_12h54m57s.png).

## Features and compatibility

- A shared profile for PowerShell 7 and Windows PowerShell 5.1 supports a random local Oh My Posh theme on each interactive startup, a fixed theme, or Starship.
- CMD loads Starship through Clink; NuShell and MSYS2 use their own generated configurations.
- The `fonts/` directory contains 48 JetBrainsMono Nerd Font TTF files for standalone offline installation. Preparing tools, modules, and themes may still require internet access.
- Fastfetch uses the repository's ASCII art and configuration. The PowerShell profile includes commands such as `y`, `fv`, `fif`, and `lg`.
- Configuration snapshots are saved per component. Restoration validates hashes and saves the current contents before making changes; existing files are replaced atomically, one file at a time.

The primary target is Windows 10/11. The scripts accommodate Windows PowerShell 5.1 syntax, but this does not imply that the latest PowerShell, Windows Terminal, or all dependencies support Windows 8.1. Upstream support depends on the OS and software versions; see the [official PowerShell installation guide](https://learn.microsoft.com/en-us/powershell/scripting/install/install-powershell-on-windows).

## Quick start

Clone the repository in PowerShell and enter its directory. If Git is unavailable, download and extract the repository, then run the scripts from the extracted directory.

```powershell
git clone https://github.com/vicky-clair/configuration_of_Terminal_and_PowerShell_for_Xia_Rui.git
cd configuration_of_Terminal_and_PowerShell_for_Xia_Rui

# On a new machine, start with the built-in Windows PowerShell; pwsh is not required.
# By default, set up PowerShell 7, Windows PowerShell 5.1, CMD, and shared dependencies.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Install-All.ps1

# Optional: also install and configure NuShell and MSYS2.
# powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Install-All.ps1 -All
```

If PowerShell 7 is already installed, you can replace `powershell.exe` with `pwsh` in these examples. Normally, run from your current user session; some software installations, WinGet source repairs, or system-wide font installations may require administrator privileges. `-ExecutionPolicy Bypass` sets the policy for the launched process only; the installer may also change the current user's execution policy. See [Deployment and rollback (Chinese)](部署与回退.md).

Install Windows Terminal separately. The PowerShell 7 installation step asks whether to apply the full Terminal settings template, which overwrites the target settings. The installer's `-NonInteractive` option skips its own selection prompts. It does not apply the full template unless `-ApplyWindowsTerminalSettings` is explicitly specified, and it does not guarantee that external package managers run without interaction.

## Individual installers and themes

Run these commands from the repository root.

| Component | Example |
| --- | --- |
| PowerShell 7, random theme | `pwsh -NoProfile -File .\Install-PowerShell7.ps1 -ThemeMode Random` |
| PowerShell 7, fixed theme | `pwsh -NoProfile -File .\Install-PowerShell7.ps1 -ThemeMode Fixed` |
| Windows PowerShell 5.1, default random theme | `powershell.exe -NoProfile -File .\Install-WinPowerShell51.ps1` |
| Windows PowerShell 5.1, Starship | `powershell.exe -NoProfile -File .\Install-WinPowerShell51.ps1 -Theme Starship` |
| CMD | `pwsh -NoProfile -File .\Install-Cmd.ps1` |
| NuShell | `pwsh -NoProfile -File .\Install-NuShell.ps1` |
| MSYS2, custom directory | `pwsh -NoProfile -File .\Install-MSYS2.ps1 -Msys2InstallPath 'D:\Tools\msys64'` |
| Offline fonts for the current user | `powershell.exe -NoProfile -File .\Install-Fonts.ps1` |

The combined installer's `-ThemeMode Random/Fixed/Starship` option is passed only to PowerShell 7. Windows PowerShell 5.1 keeps its default `Random` mode. The combined installer also supports `-SkipPowerShell7`, `-SkipWinPowerShell51`, `-SkipCmd`, `-IncludeNuShell`, and `-IncludeMSYS2`.

## Verification, deployment, and recovery

```powershell
# Check repository syntax, configuration, and profile constraints.
pwsh -NoProfile -File .\tests\Verify-Configuration.ps1

# Undo the latest installation: preview first, then act on the output.
pwsh -NoProfile -File .\Restore-All.ps1 -WhatIf
# pwsh -NoProfile -File .\Restore-All.ps1

# Sync repository configuration after dependencies have been installed.
pwsh -NoProfile -File .\Deploy-TerminalConfiguration.ps1 -WhatIf
# pwsh -NoProfile -File .\Deploy-TerminalConfiguration.ps1

# Undo that deployment, including CMD, using the separate deployment snapshot pointer.
pwsh -NoProfile -File .\Restore-TerminalConfiguration.ps1 -IncludeCmd -WhatIf
```

Recovery only handles managed configuration included in the selected snapshot. It does not uninstall software, modules, or fonts, undo every installation side effect, or provide a single transaction across multiple files and registry entries. The deployment script also configures Fastfetch, but deployment snapshots currently omit the `Shared` component; save a separate copy of shared configuration before running it. See [Deployment and rollback (Chinese)](部署与回退.md) for the full scope, legacy snapshot compatibility, and failure handling.

## Everyday commands (PowerShell profile)

| Command / shortcut | Purpose and dependencies |
| --- | --- |
| `ll` / `la` / `lt` / `llg` | Directory listing, hidden files, directory tree, and Git status; prefer eza when available |
| `catc README.md` | Syntax-highlighted preview with bat; `cat` retains its PowerShell meaning |
| `z <keyword>` / `zi` / `Alt+Z` | Directory navigation with zoxide; interactive selection requires fzf |
| `Ctrl+F` / `Ctrl+R` | PSFzf file selection / history search; require PSReadLine, PSFzf, and fzf |
| `fv` / `fif <keyword>` | Fuzzy file selection for editing / full-text search with ripgrep; require tools including fzf |
| `y` | Yazi file manager; sync the working directory on exit |
| `lg` / `Ctrl+G` | Lazygit; the shortcut requires PSReadLine and lazygit |
| `Enable-Vfox` | Enable vfox on demand; it is not activated at startup by default |
| `Test-Environment` / `Update-Profile` | Check tools and modules / reload the profile |

Aliases and shortcuts are generated per shell and may differ between shells. For default toggle values and configuration instructions, see [Terminal customization and usage (Chinese)](windows终端美化相关.md).

## Project structure

```text
├── Install-All.ps1                  # Run component installers
├── Install-*.ps1                    # Standalone shell / font installers
├── Deploy-TerminalConfiguration.ps1 # Sync configuration to an existing setup
├── Restore-All.ps1                  # Restore installation snapshots
├── Restore-TerminalConfiguration.ps1 # Restore deployment snapshots
├── Manage-TerminalConfiguration.ps1 # Manage legacy deployment.json snapshots
├── Microsoft.PowerShell_profile.ps1 # Shared PS7 / PS5.1 profile source
├── settings.json                    # Windows Terminal settings template
├── assets/                          # README screenshots
├── fonts/                           # 48 TTF font files
├── fastfetch/                       # ASCII art and system information configuration
├── starship/                        # Starship prompt configuration
├── cmd/                             # CMD AutoRun installer and Clink templates
├── scripts/                         # Shared installation, state, snapshot, and module logic
├── tests/                           # Syntax checks, isolated regression checks, and startup measurements
└── backups/                         # Historical material and locally generated backups
```

## Documentation

The detailed guides below are currently available in Simplified Chinese.

| Guide | Contents |
| --- | --- |
| [Deployment and rollback](部署与回退.md) | Installation vs. deployment, snapshot pointers, recovery scope, and failure handling |
| [Development and deployment](开发与部署文档.md) | Architecture, parameters, Chinese code comment conventions, verification, and maintenance |
| [Terminal customization and usage](windows终端美化相关.md) | Fonts, themes, wallpapers, shortcuts, toggles, and troubleshooting |
| [IDE and development tool integration](IDE与开发工具集成指南.md) | Terminal configuration for VS Code, Cursor, and JetBrains IDEs |
| [Security, stability, and performance audit (historical)](安全稳定性性能审计-2026-09-07.md) | Audit baseline and findings from September 7, 2026 |
| [Audit fixes and verification (historical)](审计修复复核-2026-09-07.md) | Fixes, verification, and measurement evidence from that review |
| [Backup directory guide](backups/README.md) | Historical material, snapshot formats, and usage limitations |

## License

Project code is licensed under the [MIT License](LICENSE). Third-party fonts and tools are subject to their respective licenses for use and distribution.
