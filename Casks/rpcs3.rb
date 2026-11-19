# frozen_string_literal: true

cask "rpcs3" do
  version "0.0.43-20640,1808e241d7b1bfb1c521e392b4c51a7d5494e9ca"

  on_arm do
    sha256 "986f37dd0ad0361845c3efb8af696ddbfe2e80801eaa47236679067991e417fd"

    url "https://github.com/RPCS3/rpcs3-binaries-mac-arm64/releases/download/build-#{version.csv.second}/rpcs3-v#{version.csv.first}-#{version.csv.second[0, 8]}_macos_aarch64.7z"
  end
  on_intel do
    sha256 "51f9e52be5232146baf98ccbdbda0c50f3e102ad5acdb653c6c2a015b95337d3"

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
