# frozen_string_literal: true

cask "rpcs3" do
  version "0.0.43-20512,461db6fab39e8e4c07b18ce7bcfbfa9591f339b2"

  on_arm do
    sha256 "2358c244f1e9e65102d4a82af79b4a1aace82badc66461157ec011c332e3169a"

    url "https://github.com/RPCS3/rpcs3-binaries-mac-arm64/releases/download/build-#{version.csv.second}/rpcs3-v#{version.csv.first}-#{version.csv.second[0, 8]}_macos_aarch64.7z"
  end
  on_intel do
    sha256 "f45eca5c907196828fcfbd778fc9ef0fbbe9dda60076c36ff53f92e3802bfec5"

    url "https://github.com/RPCS3/rpcs3-binaries-mac/releases/download/build-#{version.csv.second}/rpcs3-v#{version.csv.first}-#{version.csv.second[0, 8]}_macos.7z"
  end

  name "RPCS3"
  desc "PlayStation 3 emulator and debugger"
  homepage "https://rpcs3.net/"

  livecheck do
    url "https://github.com/RPCS3/rpcs3-binaries-mac-arm64"
    regex(/rpcs3[._-]v?(\d+(?:\.\d+)+-\d+)-\h+[._-]macos/i)
    strategy :github_latest do |json, regex|
      commit = json["tag_name"]&.delete_prefix("build-")
      next if commit.blank?

      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{commit}"
      end
    end
  end

  depends_on macos: :sequoia

  app "RPCS3.app"
end
