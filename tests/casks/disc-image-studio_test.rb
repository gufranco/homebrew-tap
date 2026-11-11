# frozen_string_literal: true

require "test_helper"

class DiscImageStudioTest < Minitest::Test
  CASK = File.expand_path("../../Casks/disc-image-studio.rb", __dir__).freeze

  def test_downloads_the_macos_command_line_build_for_each_processor
    # Arrange
    text = File.read(CASK)

    # Act
    url = text[Regexp.new('^  url "([^"]+)"$'), 1]

    # Assert
    assert_equal "https://github.com/JiaFeiMiao-K-Cat/DiscImageStudio/releases/download/v\#{version}/" \
                 "DiscImageStudio-CLI-v\#{version}-\#{arch}.tar.gz", url
    assert_includes text, %Q(  arch arm: "osx-arm64", intel: "osx-x64"\n)
  end

  def test_installs_the_single_file_command_and_no_app
    # Arrange
    text = File.read(CASK)

    # Act
    artifacts = text.scan(/^  (app|binary|pkg) "([^"]+)"$/)

    # Assert
    assert_equal [%w[binary disc-image-studio]], artifacts
  end
end
