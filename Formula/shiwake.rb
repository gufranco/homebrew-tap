# frozen_string_literal: true

class Shiwake < Formula
  desc "Sort the files of a folder into A to Z subfolders by their first letter"
  homepage "https://github.com/gufranco/shiwake"
  url "https://github.com/gufranco/shiwake/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "1c62ae610c01013dbab309e97d1bc49db69338cae7139c11ab89ea206d673052"
  license "MIT"
  head "https://github.com/gufranco/shiwake.git", branch: "main"

  def install
    libexec.install "bin", "lib"
    bin.write_exec_script libexec/"bin/shiwake"
    man1.install "man/shiwake.1"
    bash_completion.install "completions/shiwake.bash" => "shiwake"
    zsh_completion.install "completions/_shiwake"
    fish_completion.install "completions/shiwake.fish"
  end

  test do
    assert_match "shiwake #{version}", shell_output("#{bin}/shiwake --version")
    assert_match "shiwake doctor", shell_output("#{bin}/shiwake help")
    system bin/"shiwake", "doctor"
    (testpath/"box/apple").write "a"
    system bin/"shiwake", testpath/"box"
    assert_path_exists testpath/"box/A/apple"
  end
end
