# frozen_string_literal: true

cask "pixelorama" do
  version "1.2.4"
  sha256 "aef909572cb008174e758fbc36998823363e44d9eaffa974b156d4284c549ce7"

  url "https://github.com/Orama-Interactive/Pixelorama/releases/download/v#{version}/Pixelorama-Mac.dmg"
  name "Pixelorama"
  desc "Free and open-source sprite editor and pixel art tool"
  homepage "https://orama-interactive.itch.io/pixelorama"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Pixelorama.app"

  zap trash: [
    "~/Library/Application Support/Pixelorama",
    "~/Library/Saved Application State/com.orama-interactive.Pixelorama.savedState",
  ]
end
