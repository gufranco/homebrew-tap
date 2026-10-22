cask "ldtk" do
  version "1.5.3"
  sha256 "d8f8ab8f7e2001a64d7db04eac8d68ec305fd21d3404a2d40d9e0377aa5dac62"

  url "https://github.com/deepnight/ldtk/releases/download/v#{version}/mac-distribution.zip"
  name "LDtk"
  desc "Modern 2D level editor (Level Designer Toolkit)"
  homepage "https://ldtk.io/"

  livecheck do
    url "https://github.com/deepnight/ldtk"
    strategy :github_latest
  end

  depends_on :macos
  container nested: "LDtk #{version} installer.dmg"

  app "LDtk.app"
end
