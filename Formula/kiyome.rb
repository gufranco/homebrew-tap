# frozen_string_literal: true

class Kiyome < Formula
  desc "Wipe removable media and verify every chunk, catching bad bit lines"
  homepage "https://github.com/gufranco/kiyome"
  url "https://github.com/gufranco/kiyome/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "6e8a0deb914a1b58ba32d0b85b2c997f9f88fd37a3e54d94c27bbcd260cbf251"
  license "MIT"
  head "https://github.com/gufranco/kiyome.git", branch: "main"

  def install
    libexec.install "bin", "lib"
    bin.write_exec_script libexec/"bin/kiyome"
  end

  test do
    assert_match "kiyome #{version}", shell_output("#{bin}/kiyome --version")
  end
end
