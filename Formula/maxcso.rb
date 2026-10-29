# frozen_string_literal: true

class Maxcso < Formula
  desc "Fast, multithreaded CSO/ZSO/DAX compressor for PSP and PS2 disc images"
  homepage "https://github.com/unknownbrackets/maxcso"
  url "https://github.com/unknownbrackets/maxcso/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "af9c05add1a1d199ec184d3471081af1b91d591b2473800ea989c882fb632730"
  license "ISC"
  head "https://github.com/unknownbrackets/maxcso.git", branch: "master"

  depends_on "libuv"
  depends_on "lz4"
  depends_on "zlib"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "maxcso v#{version}", shell_output("#{bin}/maxcso --version 2>&1", 1)

    iso = testpath/"test.iso"
    iso.binwrite("MAXCSO-ROUNDTRIP" * 2048)
    system bin/"maxcso", "--quiet", iso, "-o", "test.cso"
    assert_path_exists testpath/"test.cso"

    system bin/"maxcso", "--quiet", "--decompress", "test.cso", "-o", "out.iso"
    assert_equal iso.binread, (testpath/"out.iso").binread
  end
end
