# IDE 与开发工具集成指南

本项目安装器配置 Shell 和 Windows Terminal，不会自动修改 VS Code、Cursor 或 JetBrains 的用户设置。IDE 终端需要单独选择 Shell 和 Nerd Font；Terminal 的壁纸、亚克力和快捷键不会直接复制到 IDE 中。安装入口见 [README](README.md)。

## 准备与适用范围

先确认目标 Shell 可以独立打开，字体已经安装。在 PowerShell 中用 `Get-Command pwsh`、`Get-Command nu` 查看实际程序位置。等宽终端优先选择已安装的 `JetBrainsMono NFM`，不使用比例版本 NFP 作为默认。缺少字体时从仓库运行 `powershell.exe -NoProfile -File .\Install-Fonts.ps1`，然后重启 IDE。

本文针对本机 Windows 集成终端。WSL、SSH、Dev Container、远程 IDE 的 Shell、配置和字体来源可能不同，不能直接套用本机 Windows 路径。

## VS Code / Cursor

VS Code 支持通过 `terminal.integrated.profiles.windows` 配置 Shell，并用 `terminal.integrated.defaultProfile.windows` 选择默认项；字体使用 `terminal.integrated.fontFamily`。参见 [VS Code 终端配置](https://code.visualstudio.com/docs/terminal/profiles)与[外观说明](https://code.visualstudio.com/docs/terminal/appearance)。Cursor 可在兼容的设置项中采用相同思路，具体界面以所用版本为准。

打开命令面板，选择 `Preferences: Open User Settings (JSON)`。将下面属性合并进已有设置对象，不要用示例覆盖整个用户配置。按需保留已安装 Shell 的条目；JSONC 支持注释。

```jsonc
{
  // Nerd Font 负责图标；备用字体不保证提供全部图标。
  "terminal.integrated.fontFamily": "'JetBrainsMono NFM', 'JetBrainsMono NF', monospace",
  "terminal.integrated.fontSize": 14,
  "terminal.integrated.defaultProfile.windows": "PowerShell 7",
  "terminal.integrated.profiles.windows": {
    "PowerShell 7": {
      "path": "pwsh.exe",
      "args": ["-NoLogo"],
      "icon": "terminal-powershell"
    },
    "Windows PowerShell 5.1": {
      "path": "${env:windir}\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
      "args": ["-NoLogo"],
      "icon": "terminal-powershell"
    },
    "CMD (Clink)": {
      "path": "${env:windir}\\System32\\cmd.exe",
      "icon": "terminal-cmd"
    },
    "NuShell": {
      "path": "nu.exe",
      "icon": "terminal"
    },
    "MSYS2 UCRT64": {
      "path": "C:\\msys64\\msys2_shell.cmd",
      "args": ["-defterm", "-here", "-no-start", "-ucrt64"],
      "icon": "terminal-bash"
    }
  },
  // 新终端隐藏横幅和提示卡，保留提示符与其他功能。
  "terminal.integrated.env.windows": {
    "POWERSHELL_PROFILE_BANNER": "0",
    "POWERSHELL_PROFILE_TIPS": "0"
  }
}
```

`pwsh.exe`、`nu.exe` 需要在 IDE 继承的 PATH 中；否则将 `path` 改为 `Get-Command` 返回的完整路径。MSYS2 路径也需按实际安装目录修改。新建终端验证，而不是只清空原终端。不要添加 `-NoProfile` 到正常使用的 PowerShell 配置，否则本项目的 Profile 不会加载。

VS Code PowerShell 扩展的专用控制台可能使用 `Microsoft.VSCode_profile.ps1`，与普通集成终端的 ConsoleHost Profile 不同。本项目默认部署后者，不保证扩展控制台自动获得相同 UI；源码还会对非 ConsoleHost 环境跳过提示符集成。

## JetBrains IDE

在 Settings → Tools → Terminal 中设置 Shell path、Environment variables，并在 Font Settings 选择终端字体。当前 IntelliJ IDEA 文档列出了专用字体区域；旧版本也可能继承 Editor → Color Scheme → Console Font。不要假定所有版本均有同名编码选项。参见 [JetBrains 终端设置](https://www.jetbrains.com/help/idea/settings-tools-terminal.html)。

| 设置 | 示例 |
| --- | --- |
| Shell path，PowerShell 7 | `pwsh.exe`，或实际路径，例如 `"C:\Program Files\PowerShell\7\pwsh.exe" -NoLogo` |
| Shell path，Windows PowerShell | `powershell.exe -NoLogo` |
| Shell path，其他 Shell | 已安装的 `cmd.exe` 或 `nu.exe` |
| Font | 已安装的 `JetBrainsMono NFM` |
| 字号 | 可从 13 或 14 开始调整 |
| Environment variables | `POWERSHELL_PROFILE_BANNER=0`、`POWERSHELL_PROFILE_TIPS=0`（可选） |

字体或环境变量修改后新建终端；如果 IDE 尚未识别刚安装的字体 / PATH，退出并重开 IDE。不同产品和 Terminal 引擎的选项可能不同，以对应版本帮助为准。

## 排障

| 现象 | 核对方法 |
| --- | --- |
| 图标是方块 | 核对实际选中的字体是否包含 Nerd Font 图标，以及是否已重启 IDE |
| 中文乱码 | 区分字体、文件编码和进程输出；Profile 设置 UTF-8 不会重新编码已有文件 |
| 外部终端正常，IDE 无提示符 | 检查 Shell 路径、是否带 `-NoProfile`、宿主名称、最小模式和环境变量 |
| 新终端仍显示横幅 | 在 IDE 终端环境设置中同时关闭 BANNER 和 TIPS；当前 Shell 的 `$env:` 修改不一定影响 IDE 创建的新进程 |
| 快捷键被 IDE 截获 | 使用 `fv`、`fif <关键词>`、`zi`、`lg`，或修改 IDE 的终端按键配置 |
| 启动慢 | 先关闭横幅 / 提示卡 / 图标逐项定位，vfox 默认保持关闭；没有统一的毫秒级速度保证 |

在普通交互 PowerShell 中可检查：

```powershell
$Host.Name
$PROFILE
$PSVersionTable.PSVersion
[Console]::OutputEncoding.CodePage
$OutputEncoding.CodePage
Test-Environment
```

`POWERSHELL_PROFILE_MINIMAL=1` 会跳过提示符、模块和 UI 初始化，适合排障，但不会卸载当前进程已加载的模块。用新进程验证；恢复正常体验时移除该设置再新开终端。更多开关见[终端美化与使用](windows终端美化相关.md)。
