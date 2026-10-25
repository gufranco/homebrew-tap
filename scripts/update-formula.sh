#!/usr/bin/env bash
set -euo pipefail

name=${1:?formula name required}
tag=${2:?tag required}
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
formula="${root}/Formula/${name}.rb"
repo="gufranco/${name}"
url="https://github.com/${repo}/archive/refs/tags/${tag}.tar.gz"

if [[ ! -f "${formula}" ]]
then
  printf 'no formula at %s\n' "${formula}" >&2
  exit 1
fi

work=$(mktemp -d "${TMPDIR:-/tmp}/tap-formula-XXXXXX")
trap 'rm -rf "$work"' EXIT

if ! curl -fsSL --retry 5 --retry-all-errors "${url}" -o "${work}/source.tar.gz"
then
  printf 'could not download %s\n' "${url}" >&2
  exit 1
fi

if command -v sha256sum >/dev/null 2>&1
then
  checksum=$(sha256sum "${work}/source.tar.gz" | awk '{print $1}')
else
  checksum=$(shasum -a 256 "${work}/source.tar.gz" | awk '{print $1}')
fi

if [[ ! "${checksum}" =~ ^[0-9a-f]{64}$ ]]
then
  printf 'computed checksum %s does not look like sha256\n' "${checksum}" >&2
  exit 1
fi

tar -xzf "${work}/source.tar.gz" -C "${work}"
packaged_manifest=$(find "${work}" -maxdepth 2 -name pyproject.toml | head -1)
shell_manifest=$(find "${work}" -maxdepth 3 -path '*/lib/core.sh' | head -1)
if [[ -n "${packaged_manifest}" ]]
then
  packaged_version=$(sed -n 's/^version = "\(.*\)"$/\1/p' "${packaged_manifest}" | head -1)
elif [[ -n "${shell_manifest}" ]]
then
  packaged_version=$(sed -n 's/^[A-Z][A-Z0-9_]*_VERSION="\([0-9][^"]*\)"$/\1/p' "${shell_manifest}" | head -1)
else
  printf 'the release archive has neither pyproject.toml nor lib/core.sh to read a version from\n' >&2
  exit 1
fi
tagged_version=${tag#v}

if [[ "${packaged_version}" != "${tagged_version}" ]]
then
  printf 'the release is tagged %s but the code in it says %s\n' "${tag}" "${packaged_version}" >&2
  exit 1
fi

python3 - "${formula}" "${url}" "${checksum}" <<'PY'
import re
import sys

path, url, checksum = sys.argv[1], sys.argv[2], sys.argv[3]
with open(path) as handle:
    text = handle.read()

text = re.sub(r'url "[^"]+"', 'url "%s"' % url, text, count=1)
text = re.sub(r'sha256 "[0-9a-f]{64}"', 'sha256 "%s"' % checksum, text, count=1)

with open(path, "w") as handle:
    handle.write(text)
PY

printf 'formula %s now points at %s\n' "${name}" "${tag}"
printf '  url:    %s\n' "${url}"
printf '  sha256: %s\n' "${checksum}"
