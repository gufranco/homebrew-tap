# frozen_string_literal: true

class Yakitsuke < Formula
  desc "Turn any video into Video CD images with subtitles that stay readable"
  homepage "https://github.com/gufranco/yakitsuke"
  url "https://github.com/gufranco/yakitsuke/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "5b92c6629454fdf494e4add8c9fd0aed5385ff166243a10700f22badbda5b11e"
  license "MIT"
  head "https://github.com/gufranco/yakitsuke.git", branch: "main"

  depends_on "ffmpeg-full"
  depends_on "gum"
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
