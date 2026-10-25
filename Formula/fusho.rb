class Fusho < Formula
  desc "Send encrypted messages through any chat using published SSH keys"
  homepage "https://github.com/gufranco/fusho"
  url "https://github.com/gufranco/fusho/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "01b863b2f6d0a70424aeb141820e35e359821a7b043c6525997545775b5beca3"
  license "MIT"
  head "https://github.com/gufranco/fusho.git", branch: "main"

  depends_on "age"

  def install
    system "bash", "build.sh"
    bin.install "dist/fusho"
    man1.install "man/fusho.1"
    bash_completion.install "completions/fusho.bash" => "fusho"
    zsh_completion.install "completions/_fusho"
    fish_completion.install "completions/fusho.fish"
  end

  test do
    assert_match "fusho #{version}", shell_output("#{bin}/fusho version")
    assert_match "fusho send", shell_output("#{bin}/fusho help")
    system bin/"fusho", "doctor"
  end
end
