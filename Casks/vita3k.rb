# frozen_string_literal: true

cask "vita3k" do
  arch arm: "arm64", intel: "intel"

  version "4319,6e9540ee"
  sha256 arm:   "541d73fea7517dc0486abd03e453f5816951d077c1e72f213717f52f4fb7740a",
         intel: "cc23402c06ec6d9046a8be8350825b04f972607f7d67ff6d8aae3c1b522b48bb"

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
