# frozen_string_literal: true

class Enban < Formula
  desc "Write, read, build and verify CD, DVD and Blu-ray discs in a terminal app"
  homepage "https://github.com/gufranco/enban"
  url "https://github.com/gufranco/enban/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "6297d84d8bb3385e4fbbf95c081d7640d729192840dc042154920d04ade2a4f0"
  license "MIT"
  head "https://github.com/gufranco/enban.git", branch: "main"

  depends_on "gum"

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
