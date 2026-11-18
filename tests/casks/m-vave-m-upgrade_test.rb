# frozen_string_literal: true

require "test_helper"

class MVaveMUpgradeTest < Minitest::Test
  CASK = File.expand_path("../../Casks/m-vave-m-upgrade.rb", __dir__).freeze

  def test_pins_the_rolling_download_by_its_last_modified_time
    # Arrange
    text = File.read(CASK)

    # Act
    url = text[Regexp.new('^  url "([^"]+)"'), 1]

    # Assert
    assert_equal "https://yms-file-store.oss-cn-hongkong.aliyuncs.com/software/pc/" \
                 "M-UPGRADE.dmg?v=\#{version}", url
    assert_match(/^  version "\d{4}\.\d{2}\.\d{2}\.\d{6}"$/, text)
    assert_match(/^  sha256 "\h{64}"$/, text)
    assert_includes text, '      Time.httpdate(headers["last-modified"]).utc.strftime("%Y.%m.%d.%H%M%S")'
  end
end
