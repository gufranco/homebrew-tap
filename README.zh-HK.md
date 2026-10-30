<div align="center">

<h1>homebrew-tap</h1>

<strong>一個 Homebrew tap，收錄 kodougu 命令行工具、我維護的其他工具，以及 Homebrew 不再提供的應用程式。</strong>

[English](README.md) | [日本語](README.ja.md) | [简体中文](README.zh-Hans.md) | 繁體中文 (香港)

[![ci](https://img.shields.io/github/actions/workflow/status/gufranco/homebrew-tap/ci.yml?branch=main&style=flat-square&label=ci)](https://github.com/gufranco/homebrew-tap/actions/workflows/ci.yml)
[![upstream](https://img.shields.io/github/actions/workflow/status/gufranco/homebrew-tap/upstream.yml?branch=main&style=flat-square&label=upstream)](https://github.com/gufranco/homebrew-tap/actions/workflows/upstream.yml)
[![license](https://img.shields.io/github/license/gufranco/homebrew-tap?style=flat-square&label=license)](LICENSE)

<p align="center">
  <a href="#quick-start"><strong>快速開始</strong></a> |
  <a href="#how-it-stays-current">如何保持最新</a> |
  <a href="#development">開發</a>
</p>

</div>

12 個 formula、8 個 cask，以及令它們保持最新的 Ruby 程式碼。tap 是一個很小的 clone：只包含 formula 和 cask 的定義，從不包含項目原始碼。

---

```console
$ brew search gufranco/tap/
gufranco/tap/anypatch
gufranco/tap/aseprite
gufranco/tap/fdstoolkit
gufranco/tap/fusho
gufranco/tap/jimaku
gufranco/tap/kakikomi
gufranco/tap/kiyome
gufranco/tap/maeyomi
gufranco/tap/marsdev
gufranco/tap/maxcso
gufranco/tap/shiwake
gufranco/tap/torrentzip
gufranco/tap/yakitsuke

gufranco/tap/furnace
gufranco/tap/lazpaint
gufranco/tap/ldtk
gufranco/tap/libresprite
gufranco/tap/lmms
gufranco/tap/pikopixel
gufranco/tap/pixelorama
gufranco/tap/sunvox
```

<a id="quick-start"></a>

## 快速開始

### 前提條件

macOS 上的 [Homebrew](https://brew.sh)。cask 和 `aseprite` 只支援 macOS。

### 安裝

```bash
brew tap gufranco/tap
brew install gufranco/tap/kakikomi
brew install --cask gufranco/tap/pixelorama
```

### 驗證

```bash
brew test gufranco/tap/kakikomi
kakikomi doctor
```

`brew test` 執行 formula 本身的測試。每個 kodougu 工具亦設有 `doctor` 指令，列出它找到的每項依賴。

## 用法

### kodougu

共用同一套介面的命令行工具，詳見各工具的 `FAMILY.md`。

| Formula | 用途 |
|:--------|:-----|
| [fusho](https://github.com/gufranco/fusho) | 使用收件人公開的 SSH 密鑰，經任何聊天工具傳送加密訊息 |
| [jimaku](https://github.com/gufranco/jimaku) | 下載影片字幕並儲存為 UTF-8 |
| [kakikomi](https://github.com/gufranco/kakikomi) | 將磁碟映像寫入可移除媒體，逐塊校驗，絕不掛載 |
| [kiyome](https://github.com/gufranco/kiyome) | 以五種經校驗的圖案覆寫磁碟，並指出有故障的位元線 |
| [shiwake](https://github.com/gufranco/shiwake) | 按首字母把資料夾內的檔案分到 A 至 Z 的子資料夾 |
| [yakitsuke](https://github.com/gufranco/yakitsuke) | 把任何影片轉換為附清晰字幕的 Video CD 映像，並分拆到多張光碟 |

### 我的其他工具

| Formula | 用途 |
|:--------|:-----|
| [anypatch](https://github.com/gufranco/anypatch) | 讀取、寫入、合併及轉換所有已公開格式的二進制修補檔 |
| [fdstoolkit](https://github.com/gufranco/fdstoolkit) | 讀取、評估、重建及寫入 Famicom 磁碟機媒體 |
| [maeyomi](https://github.com/gufranco/maeyomi) | 為 Barcode Battler 及條碼遊戲列印可用的卡片 |

### 第三方工具

| Formula | 用途 |
|:--------|:-----|
| [maxcso](https://github.com/unknownbrackets/maxcso) | 以多線程把 PSP 及 PS2 光碟映像壓縮為 CSO、ZSO 或 DAX |
| [torrentzip](https://github.com/0-wiz-0/trrntzip) | 把壓縮檔重新封裝為標準、可重現的 TorrentZip 格式；指令名稱是 `trrntzip` |
| [aseprite](https://www.aseprite.org/) | 以官方公開的原始碼及對應的預先編譯 Skia 建置 Aseprite 精靈編輯器，個人使用獲准如此建置；建置需時 |
| [marsdev](https://github.com/andwn/marsdev) | 建置用於 SEGA Mega Drive 自製軟件的 Marsdev 工具鏈，即針對 68000 的 GCC 及 SGDK；`source $(brew --prefix marsdev)/libexec/mars/mars.sh` 會設定 `MARSDEV` 及 `GDK`；建置需時 |

### 應用程式

這些 cask 在應用程式無法通過公證後被 homebrew-cask 移除。它們未經修改，並遵從 Gatekeeper 的判斷。

| Cask | 簡介 |
|:-----|:-----|
| [furnace](https://tildearrow.org/furnace/) | 多機種晶片音樂編曲器 |
| [lazpaint](https://bgrabitmap.github.io/lazpaint/) | 支援圖層、濾鏡及指令碼的圖像編輯器；經 Rosetta 2 執行 |
| [ldtk](https://ldtk.io/) | 2D 關卡編輯器 |
| [libresprite](https://libresprite.github.io/) | Aseprite 精靈編輯器的自由分支 |
| [lmms](https://lmms.io/) | 數碼音訊工作站；經 Rosetta 2 執行 |
| [pikopixel](https://twilightedge.com/mac/pikopixel/) | 針對索引調色盤圖像的像素畫編輯器；經 Rosetta 2 執行 |
| [pixelorama](https://orama-interactive.itch.io/pixelorama) | 精靈編輯器及像素畫工具 |
| [sunvox](https://www.warmplace.ru/soft/sunvox/) | 模組化合成器及編曲器 |

如果 macOS 在首次啟動時封鎖某個應用程式，可以用 `xattr -dr com.apple.quarantine /Applications/<App>.app` 移除隔離標記，或在安裝時加上 `--no-quarantine`。

<a id="how-it-stays-current"></a>

## 如何保持最新

- **我的工具發佈新版本。** 工具的儲存庫附上新標籤傳送 `formula-bump` dispatch。tap 下載該標籤的壓縮檔，確認其中的版本與標籤一致，改寫 formula 的 `url` 和 `sha256`，從原始碼建置並執行測試，之後才提交到 `main`。比 formula 現有標籤更舊的 dispatch 不會改變任何內容。
- **第三方應用程式。** 每日三次，工作會把每個 cask、`aseprite`、`marsdev`、`maxcso` 及 `torrentzip` 與上游比較，有新版本時開啟一個合併請求。修改 formula 的合併請求會從原始碼建置該 formula 並執行它的測試。合併請求的所有檢查都通過後，會自動合併。
- **tap 本身。** CI 在每次推送時執行：在 Ubuntu 和 macOS 上執行測試、檢查工作流程，並執行 Homebrew 的 style 檢查。另一個 upstream 檢查每日三次、並在每次修改 formula 或 cask 時，對每個 formula 和 cask 執行 Homebrew 的嚴格線上審核，所以下載檔案消失或改變會在數小時內顯示在它自己的徽章上，而不會令 CI 徽章變紅。Dependabot 每日三次檢查 GitHub Actions 和 gem，它的合併請求亦會以同樣方式自動合併。

<a id="development"></a>

## 開發

```bash
bundle install
bundle exec rake hooks
```

| 指令 | 說明 |
|:-----|:-----|
| `bundle exec rake test` | Minitest 測試，每個檔案都必須達到 100% 的行覆蓋率及分支覆蓋率 |
| `bundle exec rake lint` | 對工作流程執行 actionlint，對每個 YAML 檔案執行 yamllint |
| `bundle exec rake style` | 對每個 formula、cask 及 Ruby 檔案執行 Homebrew 的 tap style 規則 |
| `bundle exec rake audit` | 對每個 formula 和 cask 執行 Homebrew 的嚴格線上審核 |
| `bundle exec rake check` | lint、test 及 style |
| `bundle exec rake hooks` | 安裝執行 lint 和 test 的 pre-commit 掛鈎 |
| `bundle exec rake formula:bump NAME=x TAG=vX.Y.Z` | 如 bump 工作流程一樣，把 `Formula/x.rb` 指向某個版本 |

`rake style` 和 `rake audit` 檢查的是 Homebrew 已安裝的 tap，所以會先把該 clone fast-forward 到本 checkout 的 `HEAD`。測試會針對臨時儲存庫及壓縮檔執行真正的 `git` 和 `curl`。

## 授權

[MIT](LICENSE)
