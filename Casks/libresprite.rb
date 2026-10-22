cask "libresprite" do
  arch arm: "arm64", intel: "x86_64"

  version "1.3"
  sha256 arm:   "3a0a90ada15ec81f89a7c450c56530cbbd50a74deecee8b21aca72ee79a970de",
         intel: "b84a4e23c742226bf3dc96e2f510e3ebae6aa70e1da8537ab5ede6acaed11ebf"

  url "https://github.com/LibreSprite/LibreSprite/releases/download/v#{version}/libresprite-v#{version}-macos-#{arch}.dmg"
  name "LibreSprite"
  desc "Free and open-source fork of the Aseprite sprite editor"
  homepage "https://libresprite.github.io/"

  livecheck do
    url "https://github.com/LibreSprite/LibreSprite"
    strategy :github_latest
  end

  depends_on :macos

  app "libresprite.app"
end
