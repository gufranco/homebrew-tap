# frozen_string_literal: true

require "test_helper"

class Vita3kTest < Minitest::Test
  CASK = File.expand_path("../../Casks/vita3k.rb", __dir__).freeze

  def test_follows_the_rolling_continuous_build
    # Arrange
    text = File.read(CASK)

    # Act
    url = text[Regexp.new('^  url "([^"]+)"'), 1]

    # Assert
    assert_equal "https://github.com/Vita3K/Vita3K/releases/download/continuous/macos\#{arch}-latest.dmg", url
    assert_includes text, "  version :latest\n"
    assert_includes text, "  sha256 :no_check\n"
  end
end
