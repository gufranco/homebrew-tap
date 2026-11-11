# frozen_string_literal: true

class Nisemono < Formula
  desc "Check whether an SD card or USB drive holds what it claims"
  homepage "https://github.com/gufranco/nisemono"
  url "https://github.com/gufranco/nisemono/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "6a995625f8c5ae0ea31d476b39957fdc3558a93c20aa9254911c94854c6ba6d3"
  license "MIT"
  head "https://github.com/gufranco/nisemono.git", branch: "main"

  depends_on "gum"

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
