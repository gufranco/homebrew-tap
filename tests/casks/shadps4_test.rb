# frozen_string_literal: true

require "test_helper"

class Shadps4Test < Minitest::Test
  CASK = File.expand_path("../../Casks/shadps4.rb", __dir__).freeze

  def test_downloads_from_the_dotted_release_tag
    # Arrange
    text = File.read(CASK)

    # Act
    url = text[Regexp.new('^  url "([^"]+)"'), 1]

    # Assert
    assert_equal "https://github.com/shadps4-emu/shadPS4/releases/download/v.\#{version}/" \
                 "shadps4-macos-sdl-\#{version}.zip", url
  end

  def test_runs_the_intel_only_macos_26_binary_under_rosetta
    # Arrange
    text = File.read(CASK)

    # Act
    requirement = text[/depends_on macos: :(\w+)/, 1]

    # Assert
    assert_equal "tahoe", requirement
    assert_includes text, "    requires_rosetta\n"
    assert_includes text, %Q(  binary "shadps4"\n)
  end
end
