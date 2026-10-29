# frozen_string_literal: true

class Fusho < Formula
  desc "Send an encrypted message through any chat, using a GitHub username"
  homepage "https://github.com/gufranco/fusho"
  url "https://github.com/gufranco/fusho/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "890606b5f06214c721234c7caaafd01ecd473c9424c7abb93e703e05700fb4df"
  license "MIT"
  head "https://github.com/gufranco/fusho.git", branch: "main"

  depends_on "age"

  def install
    if File.exist?("build.sh")
      system "bash", "build.sh"
      bin.install "dist/fusho"
    else
      libexec.install "bin", "lib"
      bin.write_exec_script libexec/"bin/fusho"
    end
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
