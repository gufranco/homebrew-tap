# frozen_string_literal: true

class Zsnes < Formula
  desc "Super Nintendo emulator, ported from x86 assembly to C"
  homepage "https://github.com/xyproto/zsnes"
  url "https://github.com/xyproto/zsnes/archive/refs/tags/v2.3.9.tar.gz"
  sha256 "4c76459f298c7091e9c1270b18e7fff773ee44f8f4965150ae6436b74764ba55"
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
