# frozen_string_literal: true

cask "rpcs3" do
  on_arm do
    version "0.0.43-20664,6ecaa5607ad51159291a82ba78d54fae2fcb8f35,6ecaa560"
    sha256 "4fdb5bf922200ff72e5d560a27e3e1e8efd1ea9b3024b1881cceefa23eea7004"

    url "https://github.com/RPCS3/rpcs3-binaries-mac-arm64/releases/download/build-#{version.csv.second}/rpcs3-v#{version.csv.first}-#{version.csv.third}_macos_aarch64.7z"
  end
  on_intel do
    version "0.0.43-20664,6ecaa5607ad51159291a82ba78d54fae2fcb8f35,6ecaa560"
    sha256 "6c4d2b3244e9c3cdd9951d213080b4e30962e170db1a0e2440e0b33a85dccce7"

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
