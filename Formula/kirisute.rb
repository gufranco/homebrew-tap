# frozen_string_literal: true

class Kirisute < Formula
  desc "Cut Nintendo DS and DSi ROM files down to their real size"
  homepage "https://github.com/gufranco/kirisute"
  url "https://github.com/gufranco/kirisute/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f9890b974327381c55a2b315ffc39b93cd2a6d49f0bb30a7d878ae0ec99e4e83"
  license "MIT"
  head "https://github.com/gufranco/kirisute.git", branch: "main"

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
