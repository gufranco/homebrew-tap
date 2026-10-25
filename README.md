# gufranco/homebrew-tap

A single Homebrew tap for the tools I maintain and a few third-party apps that
Homebrew no longer ships. Tapping this is a small, fast clone: it holds only
formulae and casks, never project source.

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
brew install gufranco/tap/kakikomi
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

- Each of my project repos opens a pull request here on every release, pointing
  its formula at the new tag with a fresh checksum.
- A daily job checks the third-party casks for new upstream versions and opens a
  pull request when one appears.

Every update lands as a reviewable pull request; nothing is auto-merged.

## Development

[`scripts/update-formula.sh`](scripts/update-formula.sh) is tested with bats. `bundle install` once, then `bash scripts/coverage.sh` runs the tests under bashcov and fails below 100% line coverage.

## License

MIT. See [LICENSE](LICENSE).
