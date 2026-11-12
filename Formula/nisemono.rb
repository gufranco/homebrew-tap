# frozen_string_literal: true

class Nisemono < Formula
  desc "Check whether an SD card or USB drive holds what it claims"
  homepage "https://github.com/gufranco/nisemono"
  url "https://github.com/gufranco/nisemono/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "c3aeb15a5d200d0ccd413f7b91aaaf4990e9a9b63613e5102a957616e6d9e72e"
  license "MIT"
  head "https://github.com/gufranco/nisemono.git", branch: "main"

  depends_on "gum"
  depends_on "mtools"

  def install
    libexec.install "bin", "lib"
    bin.write_exec_script libexec/"bin/nisemono"
    man1.install "man/nisemono.1"
    bash_completion.install "completions/nisemono.bash" => "nisemono"
    zsh_completion.install "completions/_nisemono"
    fish_completion.install "completions/nisemono.fish"
  end

  test do
    assert_match "nisemono #{version}", shell_output("#{bin}/nisemono --version")
    assert_match "nisemono doctor", shell_output("#{bin}/nisemono help")
    system bin/"nisemono", "doctor"
  end
end
