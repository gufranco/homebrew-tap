# frozen_string_literal: true

class Kirisute < Formula
  desc "Cut GBA, DS, DSi and 3DS ROMs and PSP ISOs down to their real size"
  homepage "https://github.com/gufranco/kirisute"
  url "https://github.com/gufranco/kirisute/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "7915da38a36cafac6a5f55515c18fdd9bb64a4c1d0688c45163f48814dcfe29f"
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
