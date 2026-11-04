# frozen_string_literal: true

class Fusho < Formula
  desc "Send an encrypted message through any chat, using a GitHub username"
  homepage "https://github.com/gufranco/fusho"
  url "https://github.com/gufranco/fusho/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "ac7adc05f596c26fab41dd97d021e3dd7ba1f75a9c5c148c79b8b7700e9d6db4"
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
