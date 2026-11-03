# frozen_string_literal: true

class Katazuke < Formula
  desc "Clear the junk other systems leave on FAT disks and sort their folders"
  homepage "https://github.com/gufranco/katazuke"
  url "https://github.com/gufranco/katazuke/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "d202b87d28b298c9683974a7858cba55c48bada3e197da0ea3d7beae06571013"
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
