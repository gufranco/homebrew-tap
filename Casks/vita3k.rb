# frozen_string_literal: true

cask "vita3k" do
  arch arm: "arm64", intel: "intel"

  version "4272,359a0e3a"
  sha256 arm:   "394c7468e5b4a1e641438683ca985b32d36efa049ef6255039951c0c7ee1b064",
         intel: "526850585b73715bd6c096230c48090c0ef0b0b64206d6fdea172a3a71e5f0c7"

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
