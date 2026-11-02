# frozen_string_literal: true

cask "socalabs-sn76489" do
  version "1.1.10"
  sha256 "c380b8e1fe40edf26807e631792b81cd90d2b46b533fe4a7ca25dc4430f994e8"

  url "https://github.com/FigBug/SN76489/releases/download/v#{version}/SN76489.pkg"
  name "SocaLabs SN76489"
  desc "Synthesizer plugin emulating the Sega Master System sound chip"
  homepage "https://socalabs.com/synths/sn76489/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  pkg "SN76489.pkg"

  uninstall pkgutil: "com.socalabs.sn76489.*"

  zap trash: "/Library/Application Support/Rabien Software/Crash Reporter/Plugins/sn76489.json"
end
