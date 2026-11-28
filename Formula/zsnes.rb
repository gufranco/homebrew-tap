# frozen_string_literal: true

class Zsnes < Formula
  desc "Super Nintendo emulator, ported from x86 assembly to C"
  homepage "https://github.com/xyproto/zsnes"
  url "https://github.com/xyproto/zsnes/archive/refs/tags/v2.3.10.tar.gz"
  sha256 "3469aa09d6f223b3591f6900fd39adddc73a2851e1048ec608e535891bcf396e"
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
