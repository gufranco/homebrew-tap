# frozen_string_literal: true

cask "vita3k" do
  arch arm: "arm64", intel: "intel"

  version "4280,e4cf2d70"
  sha256 arm:   "601229ec276f7bf040ac867a71e54e96980fea4783c40e92a91e70540fd6562b",
         intel: "ba151fdb9819c31ebca93be8a223617ddd31d34d9e1f194c6ff9b0da5f4d8bfe"

  url "https://github.com/Vita3K/Vita3K-builds/releases/download/#{version.csv.first}/vita3k-#{version.csv.first}-#{version.csv.second}-macos-#{arch}.dmg"
  name "Vita3K"
  desc "PlayStation Vita emulator"
  homepage "https://vita3k.org/"

  livecheck do
    url "https://github.com/Vita3K/Vita3K-builds"
    regex(/vita3k[._-](\d+)[._-](\h+)[._-]macos/i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  depends_on macos: :ventura

  app "Vita3K.app"
end
