cask "lmms" do
  version "1.2.2"
  sha256 "bcf9d6693cf4000df4a4c705afb8bbaa30a3caf4e146939c983cc31eecb66eb0"

  url "https://github.com/LMMS/lmms/releases/download/v#{version}/lmms-#{version}-mac10.14.dmg"
  name "LMMS"
  desc "Free and open-source digital audio workstation"
  homepage "https://lmms.io/"

  livecheck do
    url "https://github.com/LMMS/lmms"
    strategy :github_latest
  end

  depends_on :macos

  app "LMMS.app"
end
