# frozen_string_literal: true

cask "mesen" do
  arch arm: "ARM64_AppleSilicon", intel: "x64_Intel"

  version "2.2.1"
  sha256 arm:   "9c230cc25ad0bae79fed810c9eeb21c1c507b96b1ce795bbd22ca4331ffb6e48",
         intel: "804cca46e70b9015898973b5a0a86e679d13f93a89e10813f74e3b7364c9c2d7"

  url "https://github.com/nesdev-org/MesenCE/releases/download/#{version}/Mesen_#{version}_macOS_#{arch}.zip"
  name "Mesen"
  desc "Emulator for NES, SNES, Game Boy, GBA, PC Engine, SMS and WonderSwan"
  homepage "https://github.com/nesdev-org/MesenCE"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on formula: "sdl2-compat"
  depends_on macos: :sequoia

  app "Mesen.app"
end
