# Windows Terminal・マルチシェル環境のモダン化

[English](README.md) · [简体中文](README.zh-CN.md) · **日本語**

PowerShell 7、Windows PowerShell 5.1、CMD、NuShell、MSYS2 のプロンプト、フォント、ツールのエイリアス、起動バナーを設定します。インストール前の設定スナップショットと、専用の復元コマンドも用意しています。

## スクリーンショット

![Windows Terminal 上の PowerShell：ランダムテーマ、Fastfetch のアスキーアートとシステム情報、中国語のコマンド案内](assets/Ashampoo_Snap_12h54m57s.png)

個人の PowerShell 7 環境での実際の表示例です。Oh My Posh のテーマ、Fastfetch のアスキーアート、ハードウェア情報、中国語のコマンド案内を表示しています。背景の壁紙は個人設定であり、リポジトリには含まれていません。バージョン、ハードウェア、ツールの状態、起動時間は撮影時の環境によるものです。[元の画像を表示](assets/Ashampoo_Snap_12h54m57s.png)。

## 機能と対応環境

- PowerShell 7 と Windows PowerShell 5.1 で共通のプロファイルを使用します。対話セッションの起動ごとにローカルの Oh My Posh テーマをランダムに選ぶ方式、固定テーマ、Starship に対応しています。
- CMD は Clink 経由で Starship を読み込みます。NuShell と MSYS2 には、それぞれ専用の設定を生成します。
- `fonts/` には JetBrainsMono Nerd Font の TTF ファイルが 48 個含まれ、単独でオフラインインストールできます。ツール、モジュール、テーマの準備にはネット接続が必要な場合があります。
- Fastfetch はリポジトリ内のアスキーアートと設定を使用します。PowerShell では `y`、`fv`、`fif`、`lg` などのコマンドを利用できます。
- 設定スナップショットはコンポーネントごとに保存します。復元前にハッシュを検証し、現在の内容を保存します。既存ファイルは、ファイル単位でアトミックに置き換えます。

主な対象は Windows 10/11 です。スクリプトは Windows PowerShell 5.1 の構文に配慮していますが、最新版の PowerShell、Windows Terminal、すべての依存ソフトが Windows 8.1 に対応することを意味しません。各ソフトの対応状況は OS とバージョンによって異なります。[PowerShell の公式インストールガイド](https://learn.microsoft.com/en-us/powershell/scripting/install/install-powershell-on-windows)を参照してください。

## クイックスタート

PowerShell でリポジトリをクローンし、そのディレクトリに移動します。Git がない場合はリポジトリをダウンロードして展開し、展開先でスクリプトを実行してください。

```powershell
git clone https://github.com/vicky-clair/configuration_of_Terminal_and_PowerShell_for_Xia_Rui.git
cd configuration_of_Terminal_and_PowerShell_for_Xia_Rui

# 新しい PC では標準の Windows PowerShell から開始できます。pwsh の事前導入は不要です。
# 既定では PowerShell 7、Windows PowerShell 5.1、CMD と共通の依存ソフトを設定します。
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Install-All.ps1

# 任意：NuShell と MSYS2 もインストール・設定します。
# powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Install-All.ps1 -All
```

PowerShell 7 がインストール済みなら、例の `powershell.exe` を `pwsh` に置き換えられます。通常は現在のユーザーのセッションで実行します。一部のソフトのインストール、WinGet ソースの修復、システム全体へのフォントのインストールには管理者権限が必要な場合があります。`-ExecutionPolicy Bypass` が指定するのは起動するプロセスの実行ポリシーだけですが、インストーラー自体も現在のユーザーの実行ポリシーを変更する場合があります。詳しくは[デプロイと復元（中国語）](部署与回退.md)を参照してください。

Windows Terminal は別途インストールしてください。PowerShell 7 のインストール手順では、Terminal 設定テンプレート全体を適用するか確認します。適用すると対象の設定が上書きされます。`-NonInteractive` はインストーラー自身の選択プロンプトを省略します。`-ApplyWindowsTerminalSettings` を明示しない限りテンプレート全体は適用されません。また、外部のパッケージマネージャーが完全に無人で動作することを保証するものではありません。

## 個別インストールとテーマの選択

以下のコマンドはリポジトリのルートディレクトリで実行します。

| コンポーネント | 実行例 |
| --- | --- |
| PowerShell 7、ランダムテーマ | `pwsh -NoProfile -File .\Install-PowerShell7.ps1 -ThemeMode Random` |
| PowerShell 7、固定テーマ | `pwsh -NoProfile -File .\Install-PowerShell7.ps1 -ThemeMode Fixed` |
| Windows PowerShell 5.1、既定のランダムテーマ | `powershell.exe -NoProfile -File .\Install-WinPowerShell51.ps1` |
| Windows PowerShell 5.1、Starship | `powershell.exe -NoProfile -File .\Install-WinPowerShell51.ps1 -Theme Starship` |
| CMD | `pwsh -NoProfile -File .\Install-Cmd.ps1` |
| NuShell | `pwsh -NoProfile -File .\Install-NuShell.ps1` |
| MSYS2、インストール先の指定 | `pwsh -NoProfile -File .\Install-MSYS2.ps1 -Msys2InstallPath 'D:\Tools\msys64'` |
| 現在のユーザーへのフォントのオフラインインストール | `powershell.exe -NoProfile -File .\Install-Fonts.ps1` |

一括インストーラーの `-ThemeMode Random/Fixed/Starship` は PowerShell 7 にのみ渡されます。Windows PowerShell 5.1 は既定の `Random` を使用します。一括インストーラーは `-SkipPowerShell7`、`-SkipWinPowerShell51`、`-SkipCmd`、`-IncludeNuShell`、`-IncludeMSYS2` にも対応しています。

## 検証・デプロイ・復元

```powershell
# リポジトリの構文、設定、プロファイルの制約を検証します。
pwsh -NoProfile -File .\tests\Verify-Configuration.ps1

# 直近のインストールを元に戻します。まずプレビューし、出力を確認してから実行します。
pwsh -NoProfile -File .\Restore-All.ps1 -WhatIf
# pwsh -NoProfile -File .\Restore-All.ps1

# 依存ソフトの導入後、リポジトリの設定を既存環境へ同期します。
pwsh -NoProfile -File .\Deploy-TerminalConfiguration.ps1 -WhatIf
# pwsh -NoProfile -File .\Deploy-TerminalConfiguration.ps1

# 専用のデプロイスナップショット参照を使い、CMD を含むデプロイを元に戻します。
pwsh -NoProfile -File .\Restore-TerminalConfiguration.ps1 -IncludeCmd -WhatIf
```

復元対象は、選択したスナップショットに含まれる管理対象の設定だけです。ソフト、モジュール、フォントのアンインストールや、インストールによるすべての変更の取り消しは行いません。また、複数ファイルとレジストリ全体を単一のトランザクションで復元するものではありません。デプロイスクリプトは Fastfetch も設定しますが、現在のデプロイスナップショットには `Shared` コンポーネントが含まれていません。実行前に共有設定を別途保存してください。対象範囲、旧形式のスナップショットとの互換性、失敗時の対応は[デプロイと復元（中国語）](部署与回退.md)に記載しています。

## よく使うコマンド（PowerShell プロファイル）

| コマンド / ショートカット | 用途と依存ツール |
| --- | --- |
| `ll` / `la` / `lt` / `llg` | ディレクトリ一覧、隠しファイル、ディレクトリツリー、Git 状態。利用可能なら eza を優先 |
| `catc README.md` | bat によるシンタックスハイライト表示。`cat` は PowerShell 本来の意味を維持 |
| `z <キーワード>` / `zi` / `Alt+Z` | zoxide によるディレクトリ移動。対話的な選択には fzf が必要 |
| `Ctrl+F` / `Ctrl+R` | PSFzf のファイル選択 / 履歴検索。PSReadLine、PSFzf、fzf が必要 |
| `fv` / `fif <キーワード>` | あいまい検索でファイルを選んで編集 / ripgrep による全文検索。fzf などが必要 |
| `y` | Yazi ファイルマネージャー。終了時に作業ディレクトリを同期 |
| `lg` / `Ctrl+G` | Lazygit。ショートカットには PSReadLine と lazygit が必要 |
| `Enable-Vfox` | 必要なときに vfox を有効化。既定では起動時に有効化しない |
| `Test-Environment` / `Update-Profile` | ツールとモジュールの確認 / プロファイルの再読み込み |

エイリアスとショートカットはシェルごとに生成するため、すべてのシェルで同じとは限りません。各機能の有効・無効の既定値と設定方法は[ターミナルのカスタマイズと使い方（中国語）](windows终端美化相关.md)を参照してください。

## プロジェクト構成

```text
├── Install-All.ps1                  # コンポーネントごとにインストーラーを実行
├── Install-*.ps1                    # シェル / フォントの個別インストール
├── Deploy-TerminalConfiguration.ps1 # 既存環境への設定の同期
├── Restore-All.ps1                  # インストールスナップショットの復元
├── Restore-TerminalConfiguration.ps1 # デプロイスナップショットの復元
├── Manage-TerminalConfiguration.ps1 # 旧 deployment.json スナップショットの管理
├── Microsoft.PowerShell_profile.ps1 # PS7 / PS5.1 共通のプロファイルソース
├── settings.json                    # Windows Terminal の設定テンプレート
├── assets/                          # README のスクリーンショット
├── fonts/                           # TTF フォント 48 ファイル
├── fastfetch/                       # アスキーアートとシステム情報の設定
├── starship/                        # Starship のプロンプト設定
├── cmd/                             # CMD AutoRun のインストールと Clink テンプレート
├── scripts/                         # インストール、状態、スナップショット、モジュールの共通処理
├── tests/                           # 構文検証、隔離環境での回帰検証、起動時間の測定
└── backups/                         # 過去の資料とローカルで生成されたバックアップ
```

## ドキュメント

以下の詳細ガイドは現在、簡体字中国語で提供しています。

| ガイド | 内容 |
| --- | --- |
| [デプロイと復元](部署与回退.md) | インストールとデプロイの違い、スナップショット参照、復元範囲、失敗時の対応 |
| [開発とデプロイ](开发与部署文档.md) | アーキテクチャ、パラメーター、中国語のコードコメント規約、検証と保守 |
| [ターミナルのカスタマイズと使い方](windows终端美化相关.md) | フォント、テーマ、壁紙、ショートカット、機能の切り替え、トラブルシューティング |
| [IDE・開発ツールとの連携](IDE与开发工具集成指南.md) | VS Code、Cursor、JetBrains IDE のターミナル設定 |
| [セキュリティ・安定性・性能の監査（過去の記録）](安全稳定性性能审计-2026-09-07.md) | 2026 年 9 月 7 日時点の監査基準と検出事項 |
| [監査後の修正と再検証（過去の記録）](审计修复复核-2026-09-07.md) | 当時の修正、再検証、測定の記録 |
| [バックアップディレクトリの説明](backups/README.md) | 過去の資料、スナップショット形式、利用上の制限 |

## ライセンス

プロジェクトのコードは [MIT ライセンス](LICENSE)で提供しています。サードパーティーのフォントやツールの利用・配布には、それぞれのライセンスが適用されます。
