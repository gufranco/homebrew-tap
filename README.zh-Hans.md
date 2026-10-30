<div align="center">

<h1>homebrew-tap</h1>

<strong>一个 Homebrew tap，收录 kodougu 命令行工具、我维护的其他工具，以及 Homebrew 不提供的应用。</strong>

[English](README.md) | [日本語](README.ja.md) | 简体中文 | [繁體中文 (香港)](README.zh-HK.md)

[![ci](https://img.shields.io/github/actions/workflow/status/gufranco/homebrew-tap/ci.yml?branch=main&style=flat-square&label=ci)](https://github.com/gufranco/homebrew-tap/actions/workflows/ci.yml)
[![upstream](https://img.shields.io/github/actions/workflow/status/gufranco/homebrew-tap/upstream.yml?branch=main&style=flat-square&label=upstream)](https://github.com/gufranco/homebrew-tap/actions/workflows/upstream.yml)
[![license](https://img.shields.io/github/license/gufranco/homebrew-tap?style=flat-square&label=license)](LICENSE)

<p align="center">
  <a href="#quick-start"><strong>快速开始</strong></a> |
  <a href="#how-it-stays-current">如何保持最新</a> |
  <a href="#development">开发</a>
</p>

</div>

14 个 formula、13 个 cask，以及让它们保持最新的 Ruby 代码。tap 是一个很小的 clone：只包含 formula 和 cask 的定义，从不包含项目源代码。

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
gufranco/tap/zsnes

gufranco/tap/azahar
gufranco/tap/furnace
gufranco/tap/lazpaint
gufranco/tap/ldtk
gufranco/tap/libresprite
gufranco/tap/lmms
gufranco/tap/mesen
gufranco/tap/pikopixel
gufranco/tap/pixelorama
gufranco/tap/rpcs3
gufranco/tap/shadps4
gufranco/tap/sunvox
gufranco/tap/vita3k
```

<a id="quick-start"></a>

## 快速开始

### 前提条件

macOS 上的 [Homebrew](https://brew.sh)。cask 和 `aseprite` 仅支持 macOS。

### 安装

```bash
brew tap gufranco/tap
brew install gufranco/tap/kakikomi
brew install --cask gufranco/tap/pixelorama
```

### 验证

```bash
brew test gufranco/tap/kakikomi
kakikomi doctor
```

`brew test` 运行 formula 自带的测试。每个 kodougu 工具还有 `doctor` 命令，列出它找到的每个依赖。

## 用法

### kodougu

共享同一套接口的命令行工具，详见各工具的 `FAMILY.md`。

| Formula | 用途 |
|:--------|:-----|
| [fusho](https://github.com/gufranco/fusho) | 使用收件人公开的 SSH 密钥，通过任意聊天工具发送加密消息 |
| [jimaku](https://github.com/gufranco/jimaku) | 下载视频字幕并保存为 UTF-8 |
| [kakikomi](https://github.com/gufranco/kakikomi) | 将磁盘镜像写入可移动介质，逐块校验，绝不挂载 |
| [kiyome](https://github.com/gufranco/kiyome) | 用五种经过校验的图案覆盖磁盘，并指出有故障的位线 |
| [shiwake](https://github.com/gufranco/shiwake) | 按首字母把文件夹中的文件分到 A 到 Z 的子文件夹 |
| [yakitsuke](https://github.com/gufranco/yakitsuke) | 把任意视频转换为带清晰字幕的 Video CD 镜像，并分到多张光盘 |

### 我的其他工具

| Formula | 用途 |
|:--------|:-----|
| [anypatch](https://github.com/gufranco/anypatch) | 读取、写入、合并和转换所有已公开格式的二进制补丁 |
| [fdstoolkit](https://github.com/gufranco/fdstoolkit) | 读取、评估、重建和写入 Famicom 磁碟机介质 |
| [maeyomi](https://github.com/gufranco/maeyomi) | 为 Barcode Battler 和条形码游戏打印可用的卡片 |

### 第三方工具

| Formula | 用途 |
|:--------|:-----|
| [maxcso](https://github.com/unknownbrackets/maxcso) | 以多线程将 PSP 和 PS2 光盘镜像压缩为 CSO、ZSO 或 DAX |
| [torrentzip](https://github.com/0-wiz-0/trrntzip) | 将压缩包重新打包为规范、可复现的 TorrentZip 格式；命令名为 `trrntzip` |
| [aseprite](https://www.aseprite.org/) | 用官方公开的源代码和对应的预编译 Skia 构建 Aseprite 精灵编辑器，个人使用获准这样构建；构建需要一段时间 |
| [marsdev](https://github.com/andwn/marsdev) | 构建用于世嘉 Mega Drive 自制软件的 Marsdev 工具链，即面向 68000 的 GCC 和 SGDK；`source $(brew --prefix marsdev)/libexec/mars/mars.sh` 会设置 `MARSDEV` 和 `GDK`；构建需要一段时间 |
| [zsnes](https://github.com/xyproto/zsnes) | 从把 x86 汇编移植到 C 的分支构建超级任天堂模拟器 ZSNES |

### 应用

这些 cask 在应用无法通过公证后被 homebrew-cask 移除。它们未做修改，并遵从 Gatekeeper 的判断。

| Cask | 简介 |
|:-----|:-----|
| [furnace](https://tildearrow.org/furnace/) | 多机种芯片音乐编曲器 |
| [lazpaint](https://bgrabitmap.github.io/lazpaint/) | 支持图层、滤镜和脚本的图像编辑器；通过 Rosetta 2 运行 |
| [ldtk](https://ldtk.io/) | 2D 关卡编辑器 |
| [libresprite](https://libresprite.github.io/) | Aseprite 精灵编辑器的自由分支 |
| [lmms](https://lmms.io/) | 数字音频工作站；通过 Rosetta 2 运行 |
| [pikopixel](https://twilightedge.com/mac/pikopixel/) | 面向索引调色板图像的像素画编辑器；通过 Rosetta 2 运行 |
| [pixelorama](https://orama-interactive.itch.io/pixelorama) | 精灵编辑器和像素画工具 |
| [sunvox](https://www.warmplace.ru/soft/sunvox/) | 模块化合成器和编曲器 |

### 模拟器

homebrew-cask 只接受能通过 Gatekeeper 的应用，而这些模拟器的 macOS 版本无法通过。每个 cask 都原样安装上游的构建。

| Cask | 模拟的机种 |
|:-----|:-----|
| [azahar](https://azahar-emu.org/) | 任天堂 3DS；Citra 和 Lime3DS 的后继 |
| [mesen](https://github.com/nesdev-org/MesenCE) | FC、超级任天堂、Game Boy、Game Boy Advance、PC Engine、Master System、Game Gear 和 WonderSwan；需要 macOS 15，并会安装 SDL2 |
| [rpcs3](https://rpcs3.net/) | PlayStation 3；需要 macOS 15 |
| [shadps4](https://shadps4.net/) | PlayStation 4；命令名为 `shadps4`，需要 macOS 26，通过 Rosetta 2 运行 |
| [vita3k](https://vita3k.org/) | PlayStation Vita；跟随上游的滚动构建，用 `brew upgrade --greedy` 更新 |

如果 macOS 在首次启动时阻止某个应用，可以用 `xattr -dr com.apple.quarantine /Applications/<App>.app` 移除隔离标记，或在安装时加上 `--no-quarantine`。

<a id="how-it-stays-current"></a>

## 如何保持最新

- **我的工具发布新版本。** 工具的仓库带着新标签发送 `formula-bump` dispatch。tap 下载该标签的压缩包，确认其中的版本与标签一致，改写 formula 的 `url` 和 `sha256`，从源代码构建并运行测试，之后才提交到 `main`。比 formula 当前标签更旧的 dispatch 不会改变任何东西。
- **第三方应用。** 每天三次，任务会把除 `vita3k` 外的每个 cask，以及 `aseprite`、`marsdev`、`maxcso`、`torrentzip` 和 `zsnes` 与上游对比，有新版本时开一个拉取请求。修改 formula 的拉取请求会从源代码构建该 formula 并运行它的测试。拉取请求的所有检查都通过后，它会自动合并。`vita3k` 总是下载上游最新的构建，因此没有可对比的版本。
- **tap 本身。** CI 在每次推送时运行：在 Ubuntu 和 macOS 上运行测试、检查工作流，并运行 Homebrew 的 style 检查。另一个 upstream 检查每天三次、并在每次修改 formula 或 cask 时，对每个 formula 和 cask 运行 Homebrew 的严格在线审计，因此下载文件消失或变化会在几小时内显示在它自己的徽章上，而不会让 CI 徽章变红。Dependabot 每天三次检查 GitHub Actions 和 gem，它的拉取请求也以同样方式自动合并。

<a id="development"></a>

## 开发

```bash
bundle install
bundle exec rake hooks
```

| 命令 | 说明 |
|:-----|:-----|
| `bundle exec rake test` | Minitest 测试，每个文件都必须达到 100% 的行覆盖率和分支覆盖率 |
| `bundle exec rake lint` | 对工作流运行 actionlint，对每个 YAML 文件运行 yamllint |
| `bundle exec rake style` | 对每个 formula、cask 和 Ruby 文件运行 Homebrew 的 tap style 规则 |
| `bundle exec rake audit` | 对每个 formula 和 cask 运行 Homebrew 的严格在线审计 |
| `bundle exec rake check` | lint、test 和 style |
| `bundle exec rake hooks` | 安装运行 lint 和 test 的 pre-commit 钩子 |
| `bundle exec rake formula:bump NAME=x TAG=vX.Y.Z` | 像 bump 工作流一样，把 `Formula/x.rb` 指向某个版本 |

`rake style` 和 `rake audit` 检查的是 Homebrew 已安装的 tap，所以会先把那个 clone fast-forward 到本 checkout 的 `HEAD`。测试会针对临时仓库和压缩包运行真实的 `git` 和 `curl`。

## 许可证

[MIT](LICENSE)
