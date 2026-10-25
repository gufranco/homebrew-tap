class Kakikomi < Formula
  desc "Write disk images to removable media, verified chunk by chunk, never mounted"
  homepage "https://github.com/gufranco/kakikomi"
  url "https://github.com/gufranco/kakikomi/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e06226422673a98769b5c6cac0d3f974e08921d93e0df88674969c946fae7cae"
  license "MIT"
  head "https://github.com/gufranco/kakikomi.git", branch: "main"

  depends_on "mtools"
  depends_on "wimlib"

  def install
    libexec.install "bin", "lib"
    bin.write_exec_script libexec/"bin/kakikomi"
    bin.write_exec_script libexec/"bin/kiyome"
  end

  test do
    assert_match "kakikomi #{version}", shell_output("#{bin}/kakikomi --version")
    assert_match "kiyome #{version}", shell_output("#{bin}/kiyome --version")
  end
end
