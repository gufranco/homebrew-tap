# frozen_string_literal: true

class Kirisute < Formula
  desc "Cut GBA, DS, DSi and 3DS ROMs and PSP ISOs down to their real size"
  homepage "https://github.com/gufranco/kirisute"
  url "https://github.com/gufranco/kirisute/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "05e13513bcbd0ff7d6beed033695fc12cc557819684d51212001f77c14c5638a"
  license "MIT"
  head "https://github.com/gufranco/kirisute.git", branch: "main"

  depends_on "gufranco/tap/maxcso"
  depends_on "gum"

  def install
    libexec.install "bin", "lib"
    bin.write_exec_script libexec/"bin/kirisute"
    man1.install "man/kirisute.1"
    bash_completion.install "completions/kirisute.bash" => "kirisute"
    zsh_completion.install "completions/_kirisute"
    fish_completion.install "completions/kirisute.fish"
  end

  test do
    assert_match "kirisute #{version}", shell_output("#{bin}/kirisute --version")
    assert_match "kirisute doctor", shell_output("#{bin}/kirisute help")
    system bin/"kirisute", "doctor"
  end
end
