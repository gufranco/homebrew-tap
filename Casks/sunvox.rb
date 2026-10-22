cask "sunvox" do
  version "2.1.4d"
  sha256 "acd94ae4acd6ab60bee1f5ba117082cd2ea51f7e87871f1776d11cfd24a59880"

  url "https://www.warmplace.ru/soft/sunvox/sunvox-#{version}.zip"
  name "SunVox"
  desc "Small, fast and powerful modular synthesizer and tracker"
  homepage "https://www.warmplace.ru/soft/sunvox/"

  livecheck do
    url "https://www.warmplace.ru/soft/sunvox/"
    regex(/sunvox[._-]v?(\d+(?:\.\d+)*[a-z]?)\.zip/i)
  end

  depends_on :macos

  app "sunvox/sunvox/macos/SunVox.app"
end
