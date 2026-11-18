# frozen_string_literal: true

require "test_helper"

class MVaveCubesuiteTest < Minitest::Test
  CASK = File.expand_path("../../Casks/m-vave-cubesuite.rb", __dir__).freeze

  def test_pins_the_rolling_download_by_its_last_modified_time
    # Arrange
    text = File.read(CASK)

    # Act
    url = text[Regexp.new('^  url "([^"]+)"'), 1]

    # Assert
    assert_equal "https://yms-file-store.oss-cn-hongkong.aliyuncs.com/software/pc/" \
                 "CubeSuite.dmg?v=\#{version}", url
    assert_match(/^  version "\d{4}\.\d{2}\.\d{2}\.\d{6}"$/, text)
    assert_match(/^  sha256 "\h{64}"$/, text)
    assert_includes text, '      Time.httpdate(headers["last-modified"]).utc.strftime("%Y.%m.%d.%H%M%S")'
  end

  def test_tells_the_user_the_intel_only_app_needs_rosetta
    # Arrange
    text = File.read(CASK)

    # Act
    caveats = text[/^  caveats do\n(.*?)^  end$/m, 1]

    # Assert
    assert_equal "    requires_rosetta\n", caveats
  end
end
