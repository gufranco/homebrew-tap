cask "lazpaint" do
  version "7.3"
  sha256 "eaac2b5776ad229a0f4496c407d4cf648dcc36626f2574486f0528916aa7a61c"

  url "https://github.com/bgrabitmap/lazpaint/releases/download/v#{version}/lazpaint#{version}_macos64.dmg"
  name "LazPaint"
  desc "Image editor with layers, filters and scripting"
  homepage "https://bgrabitmap.github.io/lazpaint/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "LazPaint.app"

  zap trash: "~/Library/Preferences/com.bgrabitmap.lazpaint.plist"

  caveats do
    requires_rosetta
  end
end
