class Fusho < Formula
  desc "Send an encrypted message through any chat, using a GitHub username"
  homepage "https://github.com/gufranco/fusho"
  url "https://github.com/gufranco/fusho/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "f25ba356e03fcf1c578a1626b9a93e882c54702613dc7b5d651a6e8ab59e776e"
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
