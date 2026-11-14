# frozen_string_literal: true

cask "vita3k" do
  arch arm: "arm64", intel: "intel"

  version "4341,aba7fd56"
  sha256 arm:   "7cb54507d5c9cab93dfa427549430d420946f9113f54f1c4c39469d940e7303b",
         intel: "294fd62b7b1d3d22ec4f897a322c2edf901f8c72efcba85a852f9d6095cc7763"

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
