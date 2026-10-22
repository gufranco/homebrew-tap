cask "pixelorama" do
  version "1.2.3"
  sha256 "f007d9d84a8410d568f173493055782dfadfd00772e6ea08cc087e3ae08629c5"

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
