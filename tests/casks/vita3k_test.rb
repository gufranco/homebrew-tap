# frozen_string_literal: true

require "test_helper"

class Vita3kTest < Minitest::Test
  CASK = File.expand_path("../../Casks/vita3k.rb", __dir__).freeze

  def test_downloads_the_numbered_build_from_the_builds_repository
    # Arrange
    text = File.read(CASK)

    # Act
    url = text[Regexp.new('^  url "([^"]+)"'), 1]

    # Assert
    assert_equal "https://github.com/Vita3K/Vita3K-builds/releases/download/\#{version.csv.first}/" \
                 "vita3k-\#{version.csv.first}-\#{version.csv.second}-macos-\#{arch}.dmg", url
    assert_match(/^  version "\d+,\h{8}"$/, text)
    assert_match(/^  sha256 arm:   "\h{64}",\n         intel: "\h{64}"$/, text)
    refute_includes text, ":no_check"
  end
end
