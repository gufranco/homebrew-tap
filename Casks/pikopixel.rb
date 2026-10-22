cask "pikopixel" do
  version "1.0-b10"
  sha256 "3fa29b5a3899c9a13018c791399225f7dd8ed0e6c4a02a117867f4963f048904"

  url "https://twilightedge.com/downloads/PikoPixel.#{version}.dmg"
  name "PikoPixel"
  desc "Pixel-art editor for indexed-palette images and sprites"
  homepage "https://twilightedge.com/mac/pikopixel/"

  livecheck do
    url "https://twilightedge.com/mac/pikopixel/"
    regex(/PikoPixel\.v?(\d+(?:\.\d+)*(?:-b\d+)?)\.dmg/i)
  end

  depends_on :macos

  app "PikoPixel.app"

  zap trash: "~/Library/Preferences/com.twilightedge.PikoPixel.plist"
end
