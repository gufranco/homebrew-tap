# frozen_string_literal: true

class Kakikomi < Formula
  desc "Write disk images to removable media, verified chunk by chunk, never mounted"
  homepage "https://github.com/gufranco/kakikomi"
  url "https://github.com/gufranco/kakikomi/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "094fa29a2b32edddf931f7eaf3b4ace29101dad986369c2833ce9185368b0818"
  license "MIT"
  head "https://github.com/gufranco/kakikomi.git", branch: "main"

  depends_on "gum"
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
