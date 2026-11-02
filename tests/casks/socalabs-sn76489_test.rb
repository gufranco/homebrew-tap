# frozen_string_literal: true

require "test_helper"

class SocalabsSn76489Test < Minitest::Test
  CASK = File.expand_path("../../Casks/socalabs-sn76489.rb", __dir__).freeze

  def test_installs_the_signed_package_from_the_developer_releases
    # Arrange
    text = File.read(CASK)

    # Act
    url = text[Regexp.new('^  url "([^"]+)"'), 1]

    # Assert
    assert_equal "https://github.com/FigBug/SN76489/releases/download/v\#{version}/SN76489.pkg", url
    assert_includes text, %Q(  pkg "SN76489.pkg"\n)
  end

  def test_uninstalls_every_plugin_format_the_package_receipts_name
    # Arrange
    text = File.read(CASK)

    # Act
    receipts = text[Regexp.new('uninstall pkgutil: "([^"]+)"'), 1]

    # Assert
    assert_equal "com.socalabs.sn76489.*", receipts
  end
end
