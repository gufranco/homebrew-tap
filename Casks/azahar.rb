# frozen_string_literal: true

cask "azahar" do
  version "2127.0"
  sha256 "f7fa2fc51201539baeeea2465b9e3fa38cf33a8261bc6bf6da6b0da52086a57c"

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
