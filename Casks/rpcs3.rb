# frozen_string_literal: true

cask "rpcs3" do
  on_arm do
    version "0.0.43-20663,0ca5eb0efe50ec4e8aa07892ab86d57842246eb4,0ca5eb0e"
    sha256 "138775a92c5f2557f54a856ddeb2e74bc9793080229f63f45ed5b39b0c358b33"

    url "https://github.com/RPCS3/rpcs3-binaries-mac-arm64/releases/download/build-#{version.csv.second}/rpcs3-v#{version.csv.first}-#{version.csv.third}_macos_aarch64.7z"
  end
  on_intel do
    version "0.0.43-20662,d264e2f19ff82d8313474549a8e78ae8f03b8060,d264e2f1"
    sha256 "6b63407e3f58b871c30c48a39b64cb507eeff639a725b498af8ce4732fa3439a"

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
