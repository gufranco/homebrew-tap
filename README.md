# gufranco/homebrew-tap

A single Homebrew tap for the tools I maintain and a few third-party apps that
Homebrew no longer ships. Tapping this is a small, fast clone: it holds only
formulae and casks, never project source.

[![ci](https://img.shields.io/github/actions/workflow/status/gufranco/homebrew-tap/ci.yml?branch=main&style=flat-square&label=ci)](https://github.com/gufranco/homebrew-tap/actions/workflows/ci.yml)
[![license](https://img.shields.io/github/license/gufranco/homebrew-tap?style=flat-square&label=license)](LICENSE)

## Install

```bash
brew tap gufranco/tap
```

### My tools

```bash
brew install gufranco/tap/anypatch
brew install gufranco/tap/fdstoolkit
brew install gufranco/tap/maeyomi
brew install gufranco/tap/fusho
brew install gufranco/tap/jimaku
brew install gufranco/tap/kakikomi
brew install gufranco/tap/kiyome
brew install gufranco/tap/shiwake
brew install gufranco/tap/yakitsuke
```

### Third-party apps

These are re-hosted here because their casks were removed from homebrew-cask
when the apps stopped passing notarization. The casks themselves are unchanged
and respect Gatekeeper; an un-notarized app is opened at the user's discretion.

```bash
brew install --cask gufranco/tap/pixelorama
brew install --cask gufranco/tap/pikopixel
brew install --cask gufranco/tap/lazpaint
brew install --cask gufranco/tap/ldtk
brew install --cask gufranco/tap/libresprite
brew install --cask gufranco/tap/lmms
brew install --cask gufranco/tap/sunvox
brew install --cask gufranco/tap/furnace
```

If macOS blocks an app on first launch, either remove the quarantine flag
(`xattr -dr com.apple.quarantine /Applications/<App>.app`) or install with
`--no-quarantine`.

### Built from source

Aseprite has no free binary to download, so it is a formula that compiles from
its own published source and the matching prebuilt Skia, which you are licensed
to do for personal use. The build takes a while.

```bash
brew install gufranco/tap/aseprite
```

## How it stays current

- Each of my project repos tells this tap about every release, and the tap
  commits its formula straight to `main`, pointing at the new tag with a fresh
  checksum. `brew upgrade` sees the new version within minutes.
- A daily job checks the third-party casks for new upstream versions and opens a
  pull request when one appears.

## Development

[`scripts/update-formula.sh`](scripts/update-formula.sh) is tested with bats. `bundle install` once, then `bash scripts/coverage.sh` runs the tests under bashcov and fails below 100% line coverage.

## License

MIT. See [LICENSE](LICENSE).
