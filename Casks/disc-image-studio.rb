# frozen_string_literal: true

cask "disc-image-studio" do
  arch arm: "osx-arm64", intel: "osx-x64"

  version "1.5.0"
  sha256 arm:   "b7b35f1bd36ee095d703f7bfb7b1e443da83bae7f003a18d131a411dedccd7f9",
         intel: "f8eff3d3965da7baa623084ecef14c5d07af11736e99a013b9e341603f525695"

  url "https://github.com/JiaFeiMiao-K-Cat/DiscImageStudio/releases/download/v#{version}/DiscImageStudio-CLI-v#{version}-#{arch}.tar.gz"
  name "Disc Image Studio"
  desc "Generate disc images that draw a visible picture on CDs, DVDs and Blu-rays"
  homepage "https://github.com/JiaFeiMiao-K-Cat/DiscImageStudio"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  binary "disc-image-studio"
end
