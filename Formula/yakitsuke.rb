# frozen_string_literal: true

class Yakitsuke < Formula
  desc "Turn any video into Video CD images with subtitles that stay readable"
  homepage "https://github.com/gufranco/yakitsuke"
  url "https://github.com/gufranco/yakitsuke/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "fd37ecd88c731ef8251d86192abbe9c0f48a17a83e69a663366adf2861cc8272"
  license "MIT"
  head "https://github.com/gufranco/yakitsuke.git", branch: "main"

  depends_on "ffmpeg-full"
  depends_on "mjpegtools"
  depends_on "vcdimager"

  def install
    libexec.install "bin", "lib", "share"
    bin.write_exec_script libexec/"bin/yakitsuke"
    man1.install "man/yakitsuke.1"
    bash_completion.install "completions/yakitsuke.bash" => "yakitsuke"
    zsh_completion.install "completions/_yakitsuke"
    fish_completion.install "completions/yakitsuke.fish"
  end

  test do
    assert_match "yakitsuke #{version}", shell_output("#{bin}/yakitsuke --version")
    assert_match "yakitsuke doctor", shell_output("#{bin}/yakitsuke help")
    system bin/"yakitsuke", "doctor"
  end
end
