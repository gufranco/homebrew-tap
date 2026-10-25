#!/usr/bin/env bats

setup() {
  SCRIPT="${BATS_TEST_DIRNAME}/../scripts/update-formula.sh"
}

@test "fails when no formula name is given" {
  # Arrange
  local script="${SCRIPT}"

  # Act
  run bash "${script}"

  # Assert
  [ "${status}" -ne 0 ]
  [[ "${output}" == *"formula name required"* ]]
}

@test "fails when no tag is given" {
  # Arrange
  local script="${SCRIPT}"

  # Act
  run bash "${script}" maeyomi

  # Assert
  [ "${status}" -ne 0 ]
  [[ "${output}" == *"tag required"* ]]
}

@test "fails when the named formula does not exist" {
  # Arrange
  local script="${SCRIPT}"

  # Act
  run bash "${script}" nosuchformula v1.0.0

  # Assert
  [ "${status}" -ne 0 ]
  [[ "${output}" == *"no formula at"* ]]
}

@test "reads the version of a shell project from lib/core.sh" {
  # Arrange
  local copy
  copy="$(mktemp -d)"
  mkdir -p "${copy}/scripts" "${copy}/Formula"
  cp "${SCRIPT}" "${copy}/scripts/"
  cp "${BATS_TEST_DIRNAME}/../Formula/fusho.rb" "${copy}/Formula/"

  # Act
  run bash "${copy}/scripts/update-formula.sh" fusho v2.0.0

  # Assert
  [ "${status}" -eq 0 ]
  [[ "${output}" == *"formula fusho now points at v2.0.0"* ]]
  grep -q 'archive/refs/tags/v2.0.0.tar.gz' "${copy}/Formula/fusho.rb"
  rm -rf "${copy}"
}
