#!/usr/bin/env bats

setup() {
  SCRIPT="${BATS_TEST_DIRNAME}/../scripts/update-formula.sh"
  WORK="$(mktemp -d)"
  FORMULAS="${WORK}/Formula"
  ARCHIVES="${WORK}/archives"
  mkdir -p "${FORMULAS}" "${ARCHIVES}"
  cp "${BATS_TEST_DIRNAME}/../Formula/fusho.rb" "${FORMULAS}/sample.rb"
  export TAP_ARCHIVE_BASE="file://${ARCHIVES}"
  export TAP_FORMULA_DIR="${FORMULAS}"
}

teardown() {
  rm -rf "${WORK}"
}

publish_release() {
  local tag="$1"
  local manifest="$2"
  local body="$3"
  local tree="${WORK}/tree/sample-${tag#v}"
  mkdir -p "${tree}/$(dirname "${manifest}")" "${ARCHIVES}/gufranco/sample/archive/refs/tags"
  printf '%s\n' "${body}" >"${tree}/${manifest}"
  tar -czf "${ARCHIVES}/gufranco/sample/archive/refs/tags/${tag}.tar.gz" -C "${WORK}/tree" "sample-${tag#v}"
}

shim_path_with() {
  local shims="${WORK}/shims"
  mkdir -p "${shims}"
  printf '#!/bin/sh\n%s\n' "$2" >"${shims}/$1"
  chmod +x "${shims}/$1"
  printf '%s' "${shims}"
}

path_without_sha256sum() {
  local bin="${WORK}/bin"
  local tool
  mkdir -p "${bin}"
  for tool in bash curl mktemp dirname rm tar gzip find head sed awk python3 shasum cat; do
    ln -s "$(command -v "${tool}")" "${bin}/${tool}"
  done
  printf '%s' "${bin}"
}

@test "fails when no formula name is given" {
  # Arrange
  local script="${SCRIPT}"

  # Act
  run "${RUNNER:-bash}" "${script}"

  # Assert
  [ "${status}" -ne 0 ]
  [[ "${output}" == *"formula name required"* ]]
}

@test "fails when no tag is given" {
  # Arrange
  local script="${SCRIPT}"

  # Act
  run "${RUNNER:-bash}" "${script}" maeyomi

  # Assert
  [ "${status}" -ne 0 ]
  [[ "${output}" == *"tag required"* ]]
}

@test "fails when the named formula does not exist" {
  # Arrange
  local script="${SCRIPT}"

  # Act
  run "${RUNNER:-bash}" "${script}" nosuchformula v1.0.0

  # Assert
  [ "${status}" -eq 1 ]
  [[ "${output}" == *"no formula at"* ]]
}

@test "fails when the release archive cannot be downloaded" {
  # Arrange
  local script="${SCRIPT}"

  # Act
  run "${RUNNER:-bash}" "${script}" sample v9.9.9

  # Assert
  [ "${status}" -eq 1 ]
  [[ "${output}" == *"could not download file://${ARCHIVES}/gufranco/sample/archive/refs/tags/v9.9.9.tar.gz"* ]]
}

@test "reads the version of a shell project from lib/core.sh" {
  # Arrange
  publish_release v2.1.0 lib/core.sh 'SAMPLE_VERSION="2.1.0"'

  # Act
  run "${RUNNER:-bash}" "${SCRIPT}" sample v2.1.0

  # Assert
  [ "${status}" -eq 0 ]
  [[ "${output}" == *"formula sample now points at v2.1.0"* ]]
  grep -q "url \"file://${ARCHIVES}/gufranco/sample/archive/refs/tags/v2.1.0.tar.gz\"" "${FORMULAS}/sample.rb"
}

@test "reads the version of a python project from pyproject.toml" {
  # Arrange
  publish_release v3.4.5 pyproject.toml 'version = "3.4.5"'

  # Act
  run "${RUNNER:-bash}" "${SCRIPT}" sample v3.4.5

  # Assert
  [ "${status}" -eq 0 ]
  [[ "${output}" == *"formula sample now points at v3.4.5"* ]]
}

@test "writes the archive sha256 into the formula" {
  # Arrange
  publish_release v2.1.0 lib/core.sh 'SAMPLE_VERSION="2.1.0"'
  local expected
  expected="$(shasum -a 256 "${ARCHIVES}/gufranco/sample/archive/refs/tags/v2.1.0.tar.gz" | awk '{print $1}')"

  # Act
  run "${RUNNER:-bash}" "${SCRIPT}" sample v2.1.0

  # Assert
  [ "${status}" -eq 0 ]
  grep -q "sha256 \"${expected}\"" "${FORMULAS}/sample.rb"
}

@test "hashes with shasum when sha256sum is absent" {
  # Arrange
  publish_release v2.1.0 lib/core.sh 'SAMPLE_VERSION="2.1.0"'
  local bin
  bin="$(path_without_sha256sum)"

  # Act
  run env PATH="${bin}" "${RUNNER:-bash}" "${SCRIPT}" sample v2.1.0

  # Assert
  [ "${status}" -eq 0 ]
  [[ "${output}" == *"formula sample now points at v2.1.0"* ]]
}

@test "fails when the computed checksum is not a sha256" {
  # Arrange
  publish_release v2.1.0 lib/core.sh 'SAMPLE_VERSION="2.1.0"'
  local shims
  shims="$(shim_path_with sha256sum "echo nothex  -")"

  # Act
  run env PATH="${shims}:${PATH}" "${RUNNER:-bash}" "${SCRIPT}" sample v2.1.0

  # Assert
  [ "${status}" -eq 1 ]
  [[ "${output}" == *"computed checksum nothex does not look like sha256"* ]]
}

@test "fails when the archive has no manifest to read a version from" {
  # Arrange
  publish_release v2.1.0 README.md 'no version here'

  # Act
  run "${RUNNER:-bash}" "${SCRIPT}" sample v2.1.0

  # Assert
  [ "${status}" -eq 1 ]
  [[ "${output}" == *"neither pyproject.toml nor lib/core.sh"* ]]
}

@test "fails when the tag and the code disagree on the version" {
  # Arrange
  publish_release v2.1.0 lib/core.sh 'SAMPLE_VERSION="2.0.9"'

  # Act
  run "${RUNNER:-bash}" "${SCRIPT}" sample v2.1.0

  # Assert
  [ "${status}" -eq 1 ]
  [[ "${output}" == *"tagged v2.1.0 but the code in it says 2.0.9"* ]]
}
