# frozen_string_literal: true

require "test_helper"

class MesenTest < Minitest::Test
  CASK = File.expand_path("../../Casks/mesen.rb", __dir__).freeze

  def test_downloads_the_maintained_mesen_ce_and_not_the_archived_mesen2
    # Arrange
    text = File.read(CASK)

    # Act
    url = text[Regexp.new('^  url "([^"]+)"$'), 1]

    # Assert
    assert_equal "https://github.com/nesdev-org/MesenCE/releases/download/\#{version}/" \
                 "Mesen_\#{version}_macOS_\#{arch}.zip", url
    refute_includes text, "SourMesen"
  end

  def test_unpacks_the_nested_app_archive_and_brings_the_sdl2_it_loads
    # Arrange
    text = File.read(CASK)

    # Act
    dependency = text[Regexp.new('depends_on formula: "([^"]+)"'), 1]

    # Assert
    assert_equal "sdl2-compat", dependency
    assert_includes text, %Q(  container nested: "Mesen.app.zip"\n)
  end
end
