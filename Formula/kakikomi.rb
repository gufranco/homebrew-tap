# frozen_string_literal: true

class Kakikomi < Formula
  desc "Write disk images to removable media, verified chunk by chunk, never mounted"
  homepage "https://github.com/gufranco/kakikomi"
  url "https://github.com/gufranco/kakikomi/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "c0cdfbc1a7aee41f384f54243e55b9cb036e56c132857ec5f7e4c477ae9f3153"
  license "MIT"
  head "https://github.com/gufranco/kakikomi.git", branch: "main"

  depends_on "mtools"
  depends_on "wimlib"

  def install
    libexec.install "bin", "lib"
    bin.write_exec_script libexec/"bin/kakikomi"
    man1.install "man/kakikomi.1"
    bash_completion.install "completions/kakikomi.bash" => "kakikomi"
    zsh_completion.install "completions/_kakikomi"
    fish_completion.install "completions/kakikomi.fish"
  end

  test do
    assert_match "kakikomi #{version}", shell_output("#{bin}/kakikomi --version")
    assert_match "kakikomi doctor", shell_output("#{bin}/kakikomi help")
    system bin/"kakikomi", "doctor"
  end
end
