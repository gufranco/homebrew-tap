# frozen_string_literal: true

class Zsnes < Formula
  desc "Super Nintendo emulator, ported from x86 assembly to C"
  homepage "https://github.com/xyproto/zsnes"
  url "https://github.com/xyproto/zsnes/archive/refs/tags/2.3.8.tar.gz"
  sha256 "1271e34e94120aa75e909e2bd73b6628de0ce53095926198bf8e708e23ada25c"
  license "GPL-2.0-only"
  head "https://github.com/xyproto/zsnes.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "python@3.15" => :build
  depends_on "libpng"
  depends_on "sdl3"

  uses_from_macos "zlib"

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV["ZSNES_SELFTEST"] = "1"
    ENV["SDL_VIDEODRIVER"] = "dummy"
    ENV["SDL_AUDIODRIVER"] = "dummy"
    assert_match "SELFTEST: PASS", shell_output("#{bin}/zsnes -v 0")
  end
end
