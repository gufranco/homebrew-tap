# frozen_string_literal: true

class Yakitsuke < Formula
  desc "Turn any video into Video CD images with subtitles that stay readable"
  homepage "https://github.com/gufranco/yakitsuke"
  url "https://github.com/gufranco/yakitsuke/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e670077dc7ba0b3df9ad601c4537c12c894ffec8c86755a44b564281a794d404"
  license "MIT"
  head "https://github.com/gufranco/yakitsuke.git", branch: "main"

  depends_on "ffmpeg-full"
  depends_on "mjpegtools"
  depends_on "vcdimager"

  def install
    libexec.install "bin", "lib", "share"
    bin.write_exec_script libexec/"bin/yakitsuke"
  end

  test do
    assert_match "yakitsuke #{version}", shell_output("#{bin}/yakitsuke --version")
  end
end
