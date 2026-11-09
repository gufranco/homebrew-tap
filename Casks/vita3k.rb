# frozen_string_literal: true

cask "vita3k" do
  arch arm: "arm64", intel: "intel"

  version "4285,885f9168"
  sha256 arm:   "5cc3dfcb543e9ddd49e07faa27f7e48f66e16b299e7238ff4df5e797d1ec522f",
         intel: "df1137f8db4c5cea52cded1c886bef3002354f79c67441dc495ccae221cc5e41"

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
