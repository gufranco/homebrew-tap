# frozen_string_literal: true

cask "rpcs3" do
  version "0.0.43-20641,c05ef180e787fa162ff0506231bafb5f69d53748"

  on_arm do
    sha256 "04012b493f379f5c66ab5c023439658cec693d3559dd669f7e87978460d0e968"

    url "https://github.com/RPCS3/rpcs3-binaries-mac-arm64/releases/download/build-#{version.csv.second}/rpcs3-v#{version.csv.first}-#{version.csv.second[0, 8]}_macos_aarch64.7z"
  end
  on_intel do
    sha256 "7ffc14a2301133dee5576d93531a0e0710c6d8c51b63686562c484b1aaa0ba0d"

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
