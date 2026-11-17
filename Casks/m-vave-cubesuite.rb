# frozen_string_literal: true

cask "m-vave-cubesuite" do
  version "2026.04.21.031137"
  sha256 "e60998896a1d6d7aa3fb813ee522ffa6b1f12b6256f0439e131ce9dd1905ca46"

  url "https://yms-file-store.oss-cn-hongkong.aliyuncs.com/software/pc/CubeSuite.dmg?v=#{version}"
  name "CubeSuite"
  desc "Editor for M-VAVE loopers, Cube Baby amplifiers and Chocolate controllers"
  homepage "https://www.m-vave.com/download.html"

  livecheck do
    url :url
    strategy :header_match do |headers|
      Time.httpdate(headers["last-modified"]).utc.strftime("%Y.%m.%d.%H%M%S")
    end
  end

  depends_on :macos

  app "CubeSuite.app"

  caveats do
    requires_rosetta
  end
end
