# homebrew-tap

Guidance for anyone, human or agent, changing this repository. What the tap holds and how to install from it lives in [README.md](README.md); this file covers how it is built, tested and shipped.

The tap ships the kodougu tools but is not a member of that family: it also carries other tools and third-party apps. It follows the family's tooling and quality bar in Ruby, the language Homebrew itself is written in. A coding agent's own instruction file in this repository only imports this one, so every rule lives here.

## Layout

| Path | Holds |
|:-----|:------|
| [`Formula/`](Formula) | One formula per tool, each starting with `# frozen_string_literal: true` |
| [`Casks/`](Casks) | The third-party apps homebrew-cask dropped or does not accept, and release-candidate `@beta` casks of apps it ships only as stable releases |
| [`audit_exceptions/`](audit_exceptions) | Homebrew's per-tap audit allowlists, one JSON file per list; an `@beta` cask is listed as `"any"` in `github_prerelease_allowlist.json` so the audit accepts both a release candidate and the final release |
| [`lib/homebrew_tap/`](lib/homebrew_tap) | The Ruby code behind the automation: one class per file, under the `HomebrewTap` module |
| [`tests/`](tests) | The Minitest suite: one `*_test.rb` per class, `repository_test.rb` for the rules below, the fixtures in [`tests/support/`](tests/support), and in [`tests/formula/`](tests/formula) the pins a formula must keep in step with the project it packages |
| [`Rakefile`](Rakefile) | Every command a person or CI runs |
| [`.github/workflows/`](.github/workflows) | CI, the scheduled upstream audit, the formula bump, the cask checks, the formula build and the bot merge |

## Commands

| Command | Does |
|:--------|:-----|
| `bundle exec rake test` | Minitest with SimpleCov, 100% line and branch coverage on every file of `lib/` |
| `bundle exec rake lint` | actionlint and yamllint at zero findings |
| `bundle exec rake style` | `brew style gufranco/tap`, after `tap:sync` |
| `bundle exec rake audit` | `brew audit --strict --online --tap gufranco/tap`, skipping the two livecheck version audits, after `tap:sync` |
| `bundle exec rake tap:sync` | Fast-forwards the brew tap clone to the `HEAD` of this checkout; refuses a clone with local changes or commits of its own |
| `bundle exec rake check` | lint, test and style |
| `bundle exec rake hooks` | Installs a pre-commit hook running lint and test |
| `bundle exec rake formula:bump`, `formula:verify`, `formula:publish` | The three steps of the bump workflow, read from `NAME` and `TAG` |
| `bundle exec rake pr:merge` | Squash-merges the Dependabot or `gufranco-tap-bot` pull request on `BRANCH` in `REPO` once every check on `HEAD_SHA` passed |

## Hard rules

[`tests/repository_test.rb`](tests/repository_test.rb) fails CI on any rule marked *(tested)*. A change to one of these rules changes that test in the same commit.

### Every change

- Before every push: `rake check` passes locally, then `git fetch`, because the bump bot pushes to `main` at any time. Push once per task and follow CI until it is green with zero warnings.
- When a formula or cask changes, also run `rake audit`. The `upstream` workflow's audit is the authority: a local Homebrew or Xcode toolchain can disagree with the runner. On a Mac whose `lipo` exits 1 on a PowerPC slice, PikoPixel's ppc, i386 and x86_64 binary reads as needing no Rosetta, while the runner rightly requires the caveat. Confirm such a finding with `file` and `lipo -archs` before changing anything.
- A push to `main` is safe at any moment. Never hold a push for a running workflow; when a push would be unsafe, fix the pipeline.
- Conventional commits, pushed straight to `main`. Pull requests come only from the cask checks, Dependabot and Renovate. A pull request from Dependabot or `gufranco-tap-bot` merges itself through [`bot-merge.yml`](.github/workflows/bot-merge.yml) once every check on its head commit passed; a person's or Renovate's never does.

### Adding or changing a formula or cask

- A cask declares no `container nested:`, no `url ... verified:`, no `version :latest` and no `sha256 :no_check` *(tested)*. Homebrew unwraps an archive whose only member is another archive by itself, and the online audit crashes on the inner path; `verified:` is deprecated.
- It appears in the table of all four READMEs *(tested)*, and the file starts with `# frozen_string_literal: true` *(tested)*.
- It has an automatic update path *(tested)*. A formula whose `homepage` is `https://github.com/gufranco/<name>` is bumped by that tool's release dispatch. Any other formula is named in a bump step of [`update-casks.yml`](.github/workflows/update-casks.yml); marsdev has a step of its own because its download is a pinned commit: a new release tag fails that step, which is the signal to move its URL and resources by hand. Every cask is covered by `brew bump --cask --tap`, so it pins a version and a `sha256`: when the upstream project publishes only a rolling download, find the numbered builds behind it, as vita3k does with Vita3K-builds.
- A cask or formula whose binary is Intel only declares `requires_rosetta` in its `caveats`, and the README row says it runs under Rosetta 2. Check every binary with `lipo -archs`: a local brew older than CI's may pass an audit that CI fails.

### Workflows and schedules

- Every scheduled job runs three times a day: the workflows, Dependabot and Renovate alike *(tested)*.
- Dependabot updates the actions and the gems. [Renovate](renovate.json) updates only what Dependabot cannot see: runner labels, tool versions passed to actions and [`.ruby-version`](.ruby-version). It never touches a formula, whose updates belong to the release dispatch and the scheduled bump, and it opens no dashboard issue *(tested)*.
- Every job has a `timeout-minutes` and starts with `step-security/harden-runner` *(tested)*. `actions/*` are pinned by version tag, every other action by full commit SHA with the version in a trailing comment.
- Every workflow that runs on `pull_request` is listed in the `workflow_run` trigger of `bot-merge.yml` *(tested)*, so the merge reruns when the last check finishes.
- A pull request that changes a formula builds it from source and runs its test block in [`formula-build.yml`](.github/workflows/formula-build.yml) before it can merge.
- `ci.yml` checks only what a commit can break, so its badge reflects the code. The strict online audit, which fails when an upstream download or homepage changes, lives in `upstream.yml` with its own badge.
- The audit skips `livecheck_version` and `livecheck_https_availability`, which also runs the version comparison, so a release upstream publishes before the bump pull request merges never turns `upstream` red; rpcs3 publishes daily. New versions belong to `update-casks.yml`. In exchange, every cask's livecheck reads an https URL or `:url` *(tested)*.

### Ruby and tooling

- All code is Ruby. The only other languages in the repository are YAML for the workflows, Markdown for the documentation and JSON for Homebrew's audit allowlists and the Renovate config; a workflow step calls a rake task or a single tool, never a script.
- Ruby in [`.ruby-version`](.ruby-version) is the latest stable release, which CI reads too. Gems are pinned to exact versions with [`Gemfile.lock`](Gemfile.lock) committed.
- The committed [`.gitignore`](.gitignore) lists only what the project produces. AI tooling and workspace paths stay out of it, and the repository has no `specs/` directory.
- `brew style` checks a path inside a tap with the tap rules, and any other path with the stricter rules for Homebrew's own code. A checkout outside `$(brew --repository)/Library/Taps` therefore goes through `rake style`, never a bare `brew style .`.
- Ruby follows Homebrew's tap style: `0755` octal literals, `%Q()` only for a string that interpolates and holds double quotes, single quotes for one that holds double quotes without interpolating, frozen constants, lines up to 118 columns.
- No comments in source, apart from `# frozen_string_literal: true` and the `# Arrange`, `# Act`, `# Assert` markers that open the three blocks of every test. A regex that holds a double quote is written `Regexp.new('...')`, because a literal one reads as a comment to the comment check.
- Tests drive the real `git` and `curl` against temporary repositories and `file://` archives; nothing internal is mocked. Data comes from Faker seeded in [`tests/test_helper.rb`](tests/test_helper.rb). Git runs with `LC_ALL=C` and no global or system configuration, so its output reads the same on every machine.
- Every write path has a test for ten identical calls in parallel and for the same call twice, each leaving exactly one commit.
- The four READMEs, English, Japanese, Simplified Chinese and Hong Kong Traditional Chinese, keep the same sections in the same order, and every change to one lands in all four.
- A formula is rewritten through a temporary file renamed into place, so a reader never sees it half written.

## Formula bumps

- A kodougu release runs its own `formula.yml`, which sends a `formula-bump` dispatch with `name` and `tag` through the `gufranco-tap-bot` GitHub App; the tap's [`formula-bump.yml`](.github/workflows/formula-bump.yml) receives it.
- The bump accepts only a lowercase name whose formula's `homepage` is `https://github.com/gufranco/<name>` and a numeric tag such as `v1.2.3`, with or without the `v`. It reads the version from the archive's `pyproject.toml` or `lib/core.sh`, and stops when that version differs from the tag.
- A tag older than the formula's current one leaves the formula alone, so a late dispatch never moves a formula back.
- The formula is built from source and its test block runs on macOS before the commit reaches `main`. The push retries three times, rebasing each time it loses a race.
- `setup-homebrew` replaces the workspace with a fresh fetch and links the tap to it, so a step that needs the checkout runs after it, and push credentials come from its `token` input.

## Gaps

None (as of 2026-10-30).
