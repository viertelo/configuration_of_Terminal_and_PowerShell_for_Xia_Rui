# 在调用者选定的 PowerShell 引擎中安装模块；逗号分隔名称，版本由公共函数限定。
param([string]$ModuleNames)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'TerminalSetupCommon.ps1')
Install-PSModulesIfMissing -Modules ($ModuleNames -split ',') -Edition Current
