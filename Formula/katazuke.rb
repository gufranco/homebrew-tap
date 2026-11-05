# frozen_string_literal: true

class Katazuke < Formula
  desc "Clear the junk other systems leave on FAT disks and sort their folders"
  homepage "https://github.com/gufranco/katazuke"
  url "https://github.com/gufranco/katazuke/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d6c43ff681eb4cb08904353cf6d29d25449f800dc4e1dd50a54ca279c84f7171"
  license "MIT"
  head "https://github.com/gufranco/katazuke.git", branch: "main"

  depends_on "fatsort"
  depends_on "gum"

  def install
    libexec.install "bin", "lib"
    bin.write_exec_script libexec/"bin/katazuke"
    man1.install "man/katazuke.1"
    bash_completion.install "completions/katazuke.bash" => "katazuke"
    zsh_completion.install "completions/_katazuke"
    fish_completion.install "completions/katazuke.fish"
  end

  test do
    assert_match "katazuke #{version}", shell_output("#{bin}/katazuke --version")
    assert_match "katazuke doctor", shell_output("#{bin}/katazuke help")
    system bin/"katazuke", "doctor"
  end
end
