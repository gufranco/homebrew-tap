# frozen_string_literal: true

require "json"
require "test_helper"

class OpencorePatcherBetaTest < Minitest::Test
  CASK = File.expand_path("../../Casks/opencore-patcher@beta.rb", __dir__).freeze

  def test_pins_a_release_candidate_or_the_final_release_it_moves_to
    # Arrange
    text = File.read(CASK)

    # Act
    version = text[Regexp.new('^  version "([^"]+)"$'), 1]

    # Assert
    assert_match(/\A\d+\.\d+\.\d+(?:-rc\.\d+)?\z/, version)
  end

  def test_installs_the_gui_package_of_the_tagged_release
    # Arrange
    text = File.read(CASK)

    # Act
    url = text[Regexp.new('^  url "([^"]+)"$'), 1]

    # Assert
    assert_equal "https://github.com/dortania/OpenCore-Legacy-Patcher/releases/download/\#{version}/" \
                 "OpenCore-Patcher.pkg", url
    assert_includes text, %Q(  pkg "OpenCore-Patcher.pkg"\n)
  end

  def test_livecheck_reads_prereleases_and_skips_drafts
    # Arrange
    text = File.read(CASK)

    # Act
    livecheck = text[/^  livecheck do\n(.*?)^  end\n/m, 1]

    # Assert
    assert_includes livecheck, "strategy :github_releases do |json, regex|"
    assert_includes livecheck, 'next if release["draft"]'
    refute_includes livecheck, "prerelease"
  end

  def test_the_audit_accepts_a_release_candidate_and_the_final_release
    # Arrange
    path = File.expand_path("../../audit_exceptions/github_prerelease_allowlist.json", __dir__)

    # Act
    allowlist = JSON.parse(File.read(path))

    # Assert
    assert_equal "any", allowlist["opencore-patcher@beta"]
  end

  def test_replaces_the_stable_cask_instead_of_installing_beside_it
    # Arrange
    text = File.read(CASK)

    # Act
    conflict = text[Regexp.new('^  conflicts_with cask: "([^"]+)"$'), 1]

    # Assert
    assert_equal "opencore-patcher", conflict
    assert_includes text, 'pkgutil:   "com.dortania.opencore-legacy-patcher"'
  end

  def test_a_plain_brew_upgrade_installs_each_new_release_candidate
    # Arrange
    text = File.read(CASK)

    # Act
    self_updating = text.match?(/^\s*auto_updates\b/)

    # Assert
    assert_equal false, self_updating
  end
end
