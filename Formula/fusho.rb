# frozen_string_literal: true

class Fusho < Formula
  desc "Send an encrypted message through any chat, using a GitHub username"
  homepage "https://github.com/gufranco/fusho"
  url "https://github.com/gufranco/fusho/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "4c3b341c906909c6b22f60414296fc689715e4bcb98b6952747dc151c9b572c2"
  license "MIT"
  head "https://github.com/gufranco/fusho.git", branch: "main"

  depends_on "age"
  depends_on "gum"

  def install
    libexec.install "bin", "lib"
    bin.write_exec_script libexec/"bin/fusho"
    man1.install "man/fusho.1"
    bash_completion.install "completions/fusho.bash" => "fusho"
    zsh_completion.install "completions/_fusho"
    fish_completion.install "completions/fusho.fish"
  end

  test do
    assert_match "fusho #{version}", shell_output("#{bin}/fusho version")
    assert_match "fusho send", shell_output("#{bin}/fusho help")
    system bin/"fusho", "doctor"
  end
end
