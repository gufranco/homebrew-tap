# frozen_string_literal: true

cask "azahar" do
  version "2126.2"
  sha256 "582ff52594807fc11438a8ed1596bd6db8622b0e07a856372f6bd709dc9995e7"

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
