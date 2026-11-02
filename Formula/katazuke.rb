# frozen_string_literal: true

class Katazuke < Formula
  desc "Clear the junk other systems leave on FAT disks and sort their folders"
  homepage "https://github.com/gufranco/katazuke"
  url "https://github.com/gufranco/katazuke/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "3678bb215fafbe23d59e307e8c20c3044028b5ae17ab51e40cfbfb5b45431303"
  license "MIT"
  head "https://github.com/gufranco/katazuke.git", branch: "main"

  depends_on "fatsort"

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
