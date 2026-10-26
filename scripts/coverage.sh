#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
minimum=${1:-100}
bash_bin=$(command -v bash)
ruby_bin=$(command -v ruby)
bashcov_bin="${root}/scripts/bashcov-run.rb"

rm -rf "${root}/coverage"
mkdir -p "${root}/coverage"

wrapper="${root}/coverage/bashcov-run"
{
  printf '#!%s\n' "${bash_bin}"
  printf 'export BUNDLE_GEMFILE=%q\n' "${root}/Gemfile"
  # shellcheck disable=SC2016
  printf 'exec %q -rbundler/setup %q --root %q --bash-path %q --command-name "run-$$-${RANDOM}" -- "$@"\n' \
    "${ruby_bin}" "${bashcov_bin}" "${root}" "${bash_bin}"
} >"${wrapper}"
chmod 0755 "${wrapper}"

BUNDLE_GEMFILE="${root}/Gemfile" RUNNER="${wrapper}" bats "${root}/test"

cd "${root}"
python3 scripts/coverage-gate.py '/scripts/update-formula\.sh\Z' "${minimum}" coverage/.resultset.json
