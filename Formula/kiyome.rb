# frozen_string_literal: true

class Kiyome < Formula
  desc "Wipe removable media and verify every chunk, catching bad bit lines"
  homepage "https://github.com/gufranco/kiyome"
  url "https://github.com/gufranco/kiyome/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d991cf014b4a569da53b7508f6ddb08b33ae0a60d258727459b89fcf409561c2"
  license "MIT"
  head "https://github.com/gufranco/kiyome.git", branch: "main"

  def install
    libexec.install "bin", "lib"
    bin.write_exec_script libexec/"bin/kiyome"
    man1.install "man/kiyome.1"
    bash_completion.install "completions/kiyome.bash" => "kiyome"
    zsh_completion.install "completions/_kiyome"
    fish_completion.install "completions/kiyome.fish"
  end

  test do
    assert_match "kiyome #{version}", shell_output("#{bin}/kiyome --version")
    assert_match "kiyome doctor", shell_output("#{bin}/kiyome help")
    system bin/"kiyome", "doctor"
  end
end
