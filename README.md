<div align="center">

<h1>homebrew-tap</h1>

<strong>One Homebrew tap for the kodougu command-line tools, the other tools I maintain, and the apps Homebrew does not ship.</strong>

English | [日本語](README.ja.md) | [简体中文](README.zh-Hans.md) | [繁體中文 (香港)](README.zh-HK.md)

[![ci](https://img.shields.io/github/actions/workflow/status/gufranco/homebrew-tap/ci.yml?branch=main&style=flat-square&label=ci)](https://github.com/gufranco/homebrew-tap/actions/workflows/ci.yml)
[![upstream](https://img.shields.io/github/actions/workflow/status/gufranco/homebrew-tap/upstream.yml?branch=main&style=flat-square&label=upstream)](https://github.com/gufranco/homebrew-tap/actions/workflows/upstream.yml)
[![license](https://img.shields.io/github/license/gufranco/homebrew-tap?style=flat-square&label=license)](LICENSE)

<p align="center">
  <a href="#quick-start"><strong>Quick start</strong></a> |
  <a href="#how-it-stays-current">How it stays current</a> |
  <a href="#development">Development</a>
</p>

</div>

14 formulae, 14 casks, and the Ruby code that keeps them current. Tapping it is a small clone: it holds formula and cask definitions, never project source.

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
gufranco/tap/opencore-patcher@beta
gufranco/tap/pikopixel
gufranco/tap/pixelorama
gufranco/tap/rpcs3
gufranco/tap/shadps4
gufranco/tap/sunvox
gufranco/tap/vita3k
```

<a id="quick-start"></a>

## Quick start

### Prerequisites

[Homebrew](https://brew.sh) on macOS. The casks and `aseprite` are macOS only.

### Install

```bash
brew tap gufranco/tap
brew install gufranco/tap/kakikomi
brew install --cask gufranco/tap/pixelorama
```

### Verify

```bash
brew test gufranco/tap/kakikomi
kakikomi doctor
```

`brew test` runs the formula's own test block. Every kodougu tool also has a `doctor` command that lists each dependency it found.

## Usage

### kodougu

The command-line tools that share one interface, described in each tool's `FAMILY.md`.

| Formula | What it does |
|:--------|:-------------|
| [fusho](https://github.com/gufranco/fusho) | Sends an encrypted message through any chat, using the recipient's published SSH keys |
| [jimaku](https://github.com/gufranco/jimaku) | Downloads subtitles for videos and saves them as UTF-8 |
| [kakikomi](https://github.com/gufranco/kakikomi) | Writes a disk image to removable media, verified chunk by chunk, never mounted |
| [kiyome](https://github.com/gufranco/kiyome) | Overwrites a disk with five verified patterns and names any failing bit line |
| [shiwake](https://github.com/gufranco/shiwake) | Sorts the files of a folder into A to Z subfolders by their first letter |
| [yakitsuke](https://github.com/gufranco/yakitsuke) | Turns any video into Video CD images, split across discs, with readable subtitles |

### Other tools of mine

| Formula | What it does |
|:--------|:-------------|
| [anypatch](https://github.com/gufranco/anypatch) | Reads, writes, merges and converts binary patches in every documented format |
| [fdstoolkit](https://github.com/gufranco/fdstoolkit) | Reads, judges, reconstructs and writes Famicom Disk System media |
| [maeyomi](https://github.com/gufranco/maeyomi) | Prints playable cards for Barcode Battler machines and barcode games |

### Third-party tools

| Formula | What it does |
|:--------|:-------------|
| [maxcso](https://github.com/unknownbrackets/maxcso) | Compresses PSP and PS2 disc images to CSO, ZSO or DAX, multithreaded |
| [torrentzip](https://github.com/0-wiz-0/trrntzip) | Rezips archives into the canonical, reproducible TorrentZip form; the command is `trrntzip` |
| [aseprite](https://www.aseprite.org/) | Builds the Aseprite sprite editor from its published source and the matching prebuilt Skia, which you are licensed to do for personal use; the build takes a while |
| [marsdev](https://github.com/andwn/marsdev) | Builds the Marsdev toolchain for Sega Mega Drive homebrew, GCC for the 68000 with SGDK; `source $(brew --prefix marsdev)/libexec/mars/mars.sh` sets `MARSDEV` and `GDK`; the build takes a while |
| [zsnes](https://github.com/xyproto/zsnes) | Builds ZSNES, the Super Nintendo emulator, from the fork that ported its x86 assembly to C |

### Apps

These casks were removed from homebrew-cask when the apps stopped passing notarization. They are unchanged and respect Gatekeeper.

| Cask | What it is |
|:-----|:-----------|
| [furnace](https://tildearrow.org/furnace/) | Multi-system chiptune tracker |
| [lazpaint](https://bgrabitmap.github.io/lazpaint/) | Image editor with layers, filters and scripting; runs under Rosetta 2 |
| [ldtk](https://ldtk.io/) | 2D level editor |
| [libresprite](https://libresprite.github.io/) | Free fork of the Aseprite sprite editor |
| [lmms](https://lmms.io/) | Digital audio workstation; runs under Rosetta 2 |
| [pikopixel](https://twilightedge.com/mac/pikopixel/) | Pixel-art editor for indexed-palette images; runs under Rosetta 2 |
| [pixelorama](https://orama-interactive.itch.io/pixelorama) | Sprite editor and pixel art tool |
| [sunvox](https://www.warmplace.ru/soft/sunvox/) | Modular synthesizer and tracker |

### Emulators

homebrew-cask only accepts apps that pass Gatekeeper, and the macOS builds of these emulators do not. Each cask installs the upstream build unchanged.

| Cask | What it emulates |
|:-----|:-----------------|
| [azahar](https://azahar-emu.org/) | Nintendo 3DS; the successor to Citra and Lime3DS |
| [mesen](https://github.com/nesdev-org/MesenCE) | NES, SNES, Game Boy, Game Boy Advance, PC Engine, Master System, Game Gear and WonderSwan; needs macOS 15 and installs SDL2 |
| [rpcs3](https://rpcs3.net/) | PlayStation 3; needs macOS 15 |
| [shadps4](https://shadps4.net/) | PlayStation 4; the command is `shadps4`, needs macOS 26 and runs under Rosetta 2 |
| [vita3k](https://vita3k.org/) | PlayStation Vita |

If macOS blocks an app on first launch, remove the quarantine flag with `xattr -dr com.apple.quarantine /Applications/<App>.app`, or install it with `--no-quarantine`.

### Release candidates

homebrew-cask ships these apps only as stable releases. Each cask installs the newest upstream release, release candidate or final. It conflicts with Homebrew's stable cask of the same app, so uninstall that one first.

| Cask | What it is |
|:-----|:-----------|
| [opencore-patcher@beta](https://dortania.github.io/OpenCore-Legacy-Patcher/) | OpenCore Legacy Patcher, which runs newer macOS on unsupported Macs; upstream warns that its release candidates can crash the system and lose data |

<a id="how-it-stays-current"></a>

## How it stays current

- **A release of one of my tools.** The tool's repository sends a `formula-bump` dispatch with the new tag. The tap downloads that tag's archive, checks that the version inside matches the tag, rewrites the formula's `url` and `sha256`, builds the formula from source, runs its test block, and only then commits to `main`. A dispatch for a tag older than the formula's current one changes nothing.
- **Third-party apps.** Three times a day, a job compares each cask, `aseprite`, `marsdev`, `maxcso`, `torrentzip` and `zsnes` with upstream and opens a pull request when a newer version is out. A pull request that changes a formula builds it from source and runs its test block. Once every check on the pull request passes, it merges itself.
- **The tap itself.** CI runs on every push: the tests on Ubuntu and macOS, the workflow lint, and Homebrew's style rules. A separate upstream check runs Homebrew's strict online audit of every formula and cask three times a day and on every change to them, so a download that disappears or changes shows up within hours on its own badge, without turning the CI badge red. Dependabot checks the GitHub Actions and the gems three times a day, and its pull requests merge the same way.

<a id="development"></a>

## Development

```bash
bundle install
bundle exec rake hooks
```

| Command | Description |
|:--------|:------------|
| `bundle exec rake test` | The Minitest suite, with a 100% line and branch coverage gate on every file |
| `bundle exec rake lint` | actionlint on the workflows and yamllint on every YAML file |
| `bundle exec rake style` | Homebrew's tap style rules on every formula, cask and Ruby file |
| `bundle exec rake audit` | Homebrew's strict online audit of every formula and cask |
| `bundle exec rake check` | lint, test and style |
| `bundle exec rake hooks` | A pre-commit hook that runs lint and test |
| `bundle exec rake formula:bump NAME=x TAG=vX.Y.Z` | Points `Formula/x.rb` at a release, as the bump workflow does |

`rake style` and `rake audit` check the tap Homebrew has installed, so they first fast-forward that clone to this checkout's `HEAD`. The tests run the real `git` and `curl` against temporary repositories and archives.

## License

[MIT](LICENSE)
