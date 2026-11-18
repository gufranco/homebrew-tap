# frozen_string_literal: true

cask "m-vave-m-upgrade" do
  version "2026.11.12.084215"
  sha256 "d049bb4162e7f489ee2b91c1fd7f8d89415921702c1a95e88d432743ebd29aa4"

  url "https://yms-file-store.oss-cn-hongkong.aliyuncs.com/software/pc/M-UPGRADE.dmg?v=#{version}"
  name "M-UPGRADE"
  desc "Firmware updater for M-VAVE effects pedals and SMK-37 keyboards"
  homepage "https://www.m-vave.com/download.html"

  livecheck do
    url :url
    strategy :header_match do |headers|
      Time.httpdate(headers["last-modified"]).utc.strftime("%Y.%m.%d.%H%M%S")
    end
  end

  depends_on macos: :monterey

  app "M-UPGRADE.app"
end
