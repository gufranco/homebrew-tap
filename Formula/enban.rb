# frozen_string_literal: true

class Enban < Formula
  desc "Write, read, build and verify CD, DVD and Blu-ray discs in a terminal app"
  homepage "https://github.com/gufranco/enban"
  url "https://github.com/gufranco/enban/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "38d6003004ad2c4aeb24f014e65e04a6756d2d0c071a23ffb982e18fe40ab90e"
  license "MIT"
  head "https://github.com/gufranco/enban.git", branch: "main"

  depends_on "gum"
  depends_on "xorriso"

  on_macos do
    depends_on "cdrtools"
  end

  def install
    libexec.install "bin", "lib"
    bin.write_exec_script libexec/"bin/enban"
    man1.install "man/enban.1"
    bash_completion.install "completions/enban.bash" => "enban"
    zsh_completion.install "completions/_enban"
    fish_completion.install "completions/enban.fish"
  end

  test do
    assert_match "enban #{version}", shell_output("#{bin}/enban --version")
    assert_match "enban doctor", shell_output("#{bin}/enban help")
    system bin/"enban", "doctor"
  end
end
