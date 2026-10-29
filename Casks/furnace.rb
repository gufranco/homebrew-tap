# frozen_string_literal: true

cask "furnace" do
  arch arm: "arm64", intel: "Intel"

  version "0.6.8.3"
  sha256 arm:   "3f2a925911c5e8babaedbee891bfda669305930a024af95b83a1103e55535755",
         intel: "f901c98d96b89d68bd84e4df9e73b2e16e6566ddc75c91ec24cc1dd09300f4ae"

  url "https://github.com/tildearrow/furnace/releases/download/v#{version}/furnace-#{version}-mac-#{arch}.dmg"
  name "Furnace"
  desc "Multi-system chiptune tracker (SN76489, YM2612, and many more)"
  homepage "https://tildearrow.org/furnace/"

  livecheck do
    url "https://github.com/tildearrow/furnace"
    strategy :github_latest
  end

  depends_on :macos

  app "Furnace.app"
end
