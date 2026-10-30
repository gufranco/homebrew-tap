# frozen_string_literal: true

cask "rpcs3" do
  version "0.0.43-20511,9508444d31338e89a4f4cee1d0cee1800c96d2c1"

  on_arm do
    sha256 "2b5a615cfa32707bd8598f8fd635844f48ea1117dfb82e0715a70281b27f73a3"

    url "https://github.com/RPCS3/rpcs3-binaries-mac-arm64/releases/download/build-#{version.csv.second}/rpcs3-v#{version.csv.first}-#{version.csv.second[0, 8]}_macos_aarch64.7z"
  end
  on_intel do
    sha256 "c7164256974048b032d4112f774afe39a16dfc2c55545d6c9374ba2238e0bee6"

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
