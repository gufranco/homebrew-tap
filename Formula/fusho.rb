# frozen_string_literal: true

class Fusho < Formula
  desc "Send an encrypted message through any chat, using a GitHub username"
  homepage "https://github.com/gufranco/fusho"
  url "https://github.com/gufranco/fusho/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "4577709e21c69f8092ac59158072ada3abc026f6d63c8d0b36055db419576fd9"
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
