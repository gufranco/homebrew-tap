# frozen_string_literal: true

class Nazuke < Formula
  desc "Give long file names short, readable, unique 8.3 names"
  homepage "https://github.com/gufranco/nazuke"
  url "https://github.com/gufranco/nazuke/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "60481613fd3a0aff2716a29f2382a782fe4dea7da680824aa796c747be38e843"
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
