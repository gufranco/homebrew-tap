# frozen_string_literal: true

class Kiban < Formula
  desc "Run Docker and the local databases a project needs at full speed"
  homepage "https://github.com/gufranco/kiban"
  url "https://github.com/gufranco/kiban/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "67c170ed6366ea196a6ccf97aecaa3dab8390f262473ea7eca959b7573290af7"
  license "MIT"
  head "https://github.com/gufranco/kiban.git", branch: "main"

  depends_on "docker"
  depends_on "gum"

  on_macos do
    depends_on "colima"
    depends_on "docker-compose"
  end

  def install
    libexec.install "bin", "lib"
    bin.write_exec_script libexec/"bin/kiban"
    man1.install "man/kiban.1"
    bash_completion.install "completions/kiban.bash" => "kiban"
    zsh_completion.install "completions/_kiban"
    fish_completion.install "completions/kiban.fish"
  end

  test do
    assert_match "kiban #{version}", shell_output("#{bin}/kiban --version")
    assert_match "kiban doctor", shell_output("#{bin}/kiban help")
    system bin/"kiban", "doctor"
  end
end
