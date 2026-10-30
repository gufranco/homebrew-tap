# homebrew-tap

Guidance for anyone, human or agent, changing this repository. What the tap holds and how to install from it lives in [README.md](README.md); this file covers how it is built, tested and shipped.

The tap ships the kodougu tools but is not a member of that family: it also carries other tools and third-party apps. It follows the family's tooling and quality bar in Ruby, the language Homebrew itself is written in. A coding agent's own instruction file in this repository only imports this one, so every rule lives here.

## Layout

| Path | Holds |
|:-----|:------|
| [`Formula/`](Formula) | One formula per tool, each starting with `# frozen_string_literal: true` |
| [`Casks/`](Casks) | The third-party apps homebrew-cask dropped |
| [`lib/homebrew_tap/`](lib/homebrew_tap) | The Ruby code behind the automation: one class per file, under the `HomebrewTap` module |
| [`tests/`](tests) | The Minitest suite, one `*_test.rb` per class, and the fixtures in [`tests/support/`](tests/support) |
| [`Rakefile`](Rakefile) | Every command a person or CI runs |
| [`.github/workflows/`](.github/workflows) | CI, the formula bump, the cask checks, the aseprite build and the Dependabot merge |

## Commands

| Command | Does |
|:--------|:-----|
| `bundle exec rake test` | Minitest with SimpleCov, 100% line and branch coverage on every file of `lib/` |
| `bundle exec rake lint` | actionlint and yamllint at zero findings |
| `bundle exec rake style` | `brew style gufranco/tap`, after `tap:sync` |
| `bundle exec rake audit` | `brew audit --strict --online --tap gufranco/tap`, after `tap:sync` |
| `bundle exec rake tap:sync` | Fast-forwards the brew tap clone to the `HEAD` of this checkout; refuses a clone with local changes or commits of its own |
| `bundle exec rake check` | lint, test and style |
| `bundle exec rake hooks` | Installs a pre-commit hook running lint and test |
| `bundle exec rake formula:bump`, `formula:verify`, `formula:publish` | The three steps of the bump workflow, read from `NAME` and `TAG` |

## Hard rules

- All code is Ruby. The only other languages in the repository are YAML for the workflows and Markdown for the documentation; a workflow step calls a rake task or a single tool, never a script.
- `brew style` checks a path inside a tap with the tap rules, and any other path with the stricter rules for Homebrew's own code. A checkout outside `$(brew --repository)/Library/Taps` therefore goes through `rake style`, never a bare `brew style .`.
- Ruby follows Homebrew's tap style: `0755` octal literals, `%Q()` for interpolated percent strings, frozen constants, lines up to 118 columns.
- No comments in source, apart from `# frozen_string_literal: true` and the `# Arrange`, `# Act`, `# Assert` markers that open the three blocks of every test. A regex that holds a double quote is written `Regexp.new('...')`, because a literal one reads as a comment to the comment check.
- Tests drive the real `git` and `curl` against temporary repositories and `file://` archives; nothing internal is mocked. Data comes from Faker seeded in [`tests/test_helper.rb`](tests/test_helper.rb). Git runs with `LC_ALL=C` and no global or system configuration, so its output reads the same on every machine.
- Every write path has a test for ten identical calls in parallel and for the same call twice, each leaving exactly one commit.
- A new formula or cask goes into every README in the same commit. The four READMEs, English, Japanese, Simplified Chinese and Hong Kong Traditional Chinese, keep the same sections in the same order.
- A formula is rewritten through a temporary file renamed into place, so a reader never sees it half written.
- Conventional commits, pushed straight to `main`. Pull requests come only from the cask checks, Dependabot and Renovate; a Dependabot one merges itself once CI passes.

## Formula bumps

- A kodougu release runs its own `formula.yml`, which sends a `formula-bump` dispatch with `name` and `tag` through the `gufranco-tap-bot` GitHub App; the tap's [`formula-bump.yml`](.github/workflows/formula-bump.yml) receives it.
- The bump accepts only a lowercase name whose formula's `homepage` is `https://github.com/gufranco/<name>` and a tag of the form `vX.Y.Z`. It reads the version from the archive's `pyproject.toml` or `lib/core.sh`, and stops when that version differs from the tag.
- A tag older than the formula's current one leaves the formula alone, so a late dispatch never moves a formula back.
- The formula is built from source and its test block runs on macOS before the commit reaches `main`. The push retries three times, rebasing each time it loses a race.
- `setup-homebrew` replaces the workspace with a fresh fetch and links the tap to it, so a step that needs the checkout runs after it, and push credentials come from its `token` input.

## Gaps

None (as of 2026-10-29).
