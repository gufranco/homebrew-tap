# frozen_string_literal: true

class Yakitsuke < Formula
  desc "Turn any video into Video CD images with subtitles that stay readable"
  homepage "https://github.com/gufranco/yakitsuke"
  url "https://github.com/gufranco/yakitsuke/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "85930e38f0d63e5a1d5019592d1c6186a332349c1c20b3eab042e23cc5aa7c2f"
  license "MIT"
  head "https://github.com/gufranco/yakitsuke.git", branch: "main"

  depends_on "ffmpeg-full"
  depends_on "mjpegtools"
  depends_on "vcdimager"

  def install
    libexec.install "bin", "lib", "share"
    (bin/"yakitsuke").write_env_script libexec/"bin/yakitsuke", PATH: "#{formula_opt_bin("ffmpeg-full")}:$PATH"
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
