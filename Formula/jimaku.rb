# frozen_string_literal: true

class Jimaku < Formula
  desc "Download subtitles for videos and save them as UTF-8"
  homepage "https://github.com/gufranco/jimaku"
  url "https://github.com/gufranco/jimaku/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "50322da15f969dff23453b98c9fb2e6dbaf583ff3aa5217dd2e402a1dd1a9195"
  license "MIT"
  head "https://github.com/gufranco/jimaku.git", branch: "main"

  depends_on "subliminal"

  def install
    libexec.install "bin", "lib"
    bin.write_exec_script libexec/"bin/jimaku"
    man1.install "man/jimaku.1"
    bash_completion.install "completions/jimaku.bash" => "jimaku"
    zsh_completion.install "completions/_jimaku"
    fish_completion.install "completions/jimaku.fish"
  end

  test do
    assert_match "jimaku #{version}", shell_output("#{bin}/jimaku --version")
    assert_match "jimaku doctor", shell_output("#{bin}/jimaku help")
    system bin/"jimaku", "doctor"
    (testpath/"films/movie.mkv").write ""
    assert_match "Videos: 1 in #{testpath}/films", shell_output("#{bin}/jimaku --dry-run #{testpath}/films")
  end
end
