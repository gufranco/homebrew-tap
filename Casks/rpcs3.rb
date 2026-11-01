# frozen_string_literal: true

cask "rpcs3" do
  version "0.0.43-20551,ad468a13f6374f364467a9e4988e95938c37bb42"

  on_arm do
    sha256 "9b8042f8394393bd3e5bab34660dbce28f5ebd878f0517b4a531ddfabf9fec5e"

    url "https://github.com/RPCS3/rpcs3-binaries-mac-arm64/releases/download/build-#{version.csv.second}/rpcs3-v#{version.csv.first}-#{version.csv.second[0, 8]}_macos_aarch64.7z"
  end
  on_intel do
    sha256 "80f1cdf6c38e1dd0cd74bb76506b18e77346eb8adf80a29b4c16ee4ddb453286"

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
