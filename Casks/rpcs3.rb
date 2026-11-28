# frozen_string_literal: true

cask "rpcs3" do
  on_arm do
    version "0.0.43-20644,3bfac607760d39dcdbe77eb137ab6dbb723b3b36,3bfac607"
    sha256 "a5656ea5ea9c52c0867fcdaab8d7a2895142000f2cf66a30148dc2e71551705c"

    url "https://github.com/RPCS3/rpcs3-binaries-mac-arm64/releases/download/build-#{version.csv.second}/rpcs3-v#{version.csv.first}-#{version.csv.third}_macos_aarch64.7z"
  end
  on_intel do
    version "0.0.43-20644,3bfac607760d39dcdbe77eb137ab6dbb723b3b36,3bfac607"
    sha256 "294211f07d8fd2ec51a93a2117e0415fee480c68a284df984b477af06abe7fd9"

    url "https://github.com/RPCS3/rpcs3-binaries-mac/releases/download/build-#{version.csv.second}/rpcs3-v#{version.csv.first}-#{version.csv.third}_macos.7z"
  end

  name "RPCS3"
  desc "PlayStation 3 emulator and debugger"
  homepage "https://rpcs3.net/"

  livecheck do
    url :url
    regex(/rpcs3[._-]v?(\d+(?:\.\d+)+-\d+)-\h+[._-]macos/i)
    strategy :github_latest do |json, regex|
      commit = json["tag_name"]&.delete_prefix("build-")
      next if commit.blank?

      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{commit},#{commit[0, 8]}"
      end
    end
  end

  depends_on macos: :sequoia

  app "RPCS3.app"
end
