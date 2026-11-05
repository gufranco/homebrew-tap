# frozen_string_literal: true

class Nazuke < Formula
  desc "Give long file names short, readable, unique 8.3 names"
  homepage "https://github.com/gufranco/nazuke"
  url "https://github.com/gufranco/nazuke/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "5b810ae845d7f13b1bb53698a6d3a210c6386e9d6878ed4e9810ebc336c3ff66"
  license "MIT"
  head "https://github.com/gufranco/nazuke.git", branch: "main"

  depends_on "gum"

  def install
    libexec.install "bin", "lib", "share"
    bin.write_exec_script libexec/"bin/nazuke"
    man1.install "man/nazuke.1"
    bash_completion.install "completions/nazuke.bash" => "nazuke"
    zsh_completion.install "completions/_nazuke"
    fish_completion.install "completions/nazuke.fish"
  end

  test do
    assert_match "nazuke #{version}", shell_output("#{bin}/nazuke --version")
    assert_match "nazuke doctor", shell_output("#{bin}/nazuke help")
    system bin/"nazuke", "doctor"
    (testpath/"box/Super Mario World (USA).sfc").write "a"
    system bin/"nazuke", "rename", testpath/"box"
    assert_path_exists testpath/"box/SUPERMW.SFC"
  end
end
