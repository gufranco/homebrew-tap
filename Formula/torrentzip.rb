# frozen_string_literal: true

class Torrentzip < Formula
  desc "Rezip archives into the canonical, reproducible TorrentZip form"
  homepage "https://github.com/0-wiz-0/trrntzip"
  url "https://github.com/0-wiz-0/trrntzip/archive/refs/tags/v1.3.tar.gz"
  sha256 "bd387f2766cef535b8e0992504c0a99dd663fdcd35d447ff8cbc14a6de70aa79"
  license "GPL-2.0-or-later"
  head "https://github.com/0-wiz-0/trrntzip.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "TorrentZip v#{version}", shell_output("#{bin}/trrntzip -v")

    (testpath/"a.txt").write("torrentzip round trip")
    system "zip", "-q", "sample.zip", "a.txt"
    system bin/"trrntzip", "sample.zip"
    assert_match "a.txt", shell_output("unzip -l sample.zip")
  end
end
