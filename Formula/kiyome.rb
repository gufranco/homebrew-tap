# frozen_string_literal: true

class Kiyome < Formula
  desc "Wipe removable media and verify every chunk, catching bad bit lines"
  homepage "https://github.com/gufranco/kiyome"
  url "https://github.com/gufranco/kiyome/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "64b66d786b8c4cebe6ad20c4a4d106ae514cdf28e2654c95085a377aad799ebb"
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
