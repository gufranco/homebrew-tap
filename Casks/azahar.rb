# frozen_string_literal: true

cask "azahar" do
  version "2127.0.1"
  sha256 "0ac504d8e04ba16b9b4ea9cdc5128f74ca7793f6977dbaf5d7c2a0c3e8cc9c1f"

  url "https://github.com/azahar-emu/azahar/releases/download/#{version}/azahar-macos-universal-#{version}.zip"
  name "Azahar"
  desc "Nintendo 3DS emulator"
  homepage "https://azahar-emu.org/"

  livecheck do
    url "https://github.com/azahar-emu/azahar"
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "azahar-macos-universal-#{version}/Azahar.app"
end
