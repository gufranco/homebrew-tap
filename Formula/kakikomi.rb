class Kakikomi < Formula
  desc "Write disk images to removable media, verified chunk by chunk, never mounted"
  homepage "https://github.com/gufranco/kakikomi"
  url "https://github.com/gufranco/kakikomi/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "ae64c597c07b0008851a287dfdf22cd9746ab1a71a2cb352b4d3eb38e5c64481"
  license "MIT"
  head "https://github.com/gufranco/kakikomi.git", branch: "main"

  depends_on "mtools"
  depends_on "wimlib"

  def install
    libexec.install "bin", "lib"
    bin.write_exec_script libexec/"bin/kakikomi"
  end

  test do
    assert_match "kakikomi #{version}", shell_output("#{bin}/kakikomi --version")
  end
end
