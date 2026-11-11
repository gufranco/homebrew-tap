# frozen_string_literal: true

class Enban < Formula
  desc "Write, read, build and verify CD, DVD and Blu-ray discs in a terminal app"
  homepage "https://github.com/gufranco/enban"
  url "https://github.com/gufranco/enban/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "b60d1980c8715ee2a648f1ef3237e2958598d84debba064d8010a0e41c5db710"
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
