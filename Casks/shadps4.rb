# frozen_string_literal: true

cask "shadps4" do
  version "0.21.0"
  sha256 "391b585d3131ebf69c585410349117d9436e529151e430156c02f7ffde364b8f"

  url "https://github.com/shadps4-emu/shadPS4/releases/download/v.#{version}/shadps4-macos-sdl-#{version}.zip",
      verified: "github.com/shadps4-emu/shadPS4/"
  name "shadPS4"
  desc "PlayStation 4 emulator"
  homepage "https://shadps4.net/"

  livecheck do
    url "https://github.com/shadps4-emu/shadPS4"
    strategy :github_latest
  end

  depends_on macos: ">= :tahoe"

  binary "shadps4"

  caveats do
    requires_rosetta
  end
end
