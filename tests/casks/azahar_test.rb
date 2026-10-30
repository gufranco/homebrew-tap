# frozen_string_literal: true

require "test_helper"

class AzaharTest < Minitest::Test
  CASK = File.expand_path("../../Casks/azahar.rb", __dir__).freeze

  def test_installs_the_universal_build_for_both_architectures
    # Arrange
    text = File.read(CASK)

    # Act
    url = text[Regexp.new('^  url "([^"]+)"'), 1]

    # Assert
    assert_equal "https://github.com/azahar-emu/azahar/releases/download/\#{version}/" \
                 "azahar-macos-universal-\#{version}.zip", url
    refute_includes text, "arch "
  end

  def test_installs_the_app_from_the_versioned_folder_inside_the_archive
    # Arrange
    text = File.read(CASK)

    # Act
    app = text[Regexp.new('^  app "([^"]+)"$'), 1]

    # Assert
    assert_equal "azahar-macos-universal-\#{version}/Azahar.app", app
  end
end
