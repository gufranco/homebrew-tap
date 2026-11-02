# frozen_string_literal: true

class Aseprite < Formula
  desc "Animated sprite editor and pixel art tool"
  homepage "https://www.aseprite.org/"
  url "https://github.com/aseprite/aseprite/releases/download/v1.3.18.6/Aseprite-v1.3.18.6-Source.zip"
  sha256 "fa9dd07a0c2a5ec91a4166333296bbb9e5c237933b59875d0cfee849d2358306"
  license :cannot_represent
  revision 1

  livecheck do
    url "https://github.com/aseprite/aseprite"
    strategy :github_latest
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on :macos

  resource "skia" do
    on_arm do
      url "https://github.com/aseprite/skia/releases/download/m124-08a5439a6b/Skia-macOS-Release-arm64.zip"
      sha256 "22663000967fc2c3f1a78190082228474955de02ffd13a352b39a48b204dac9a"
    end
    on_intel do
      url "https://github.com/aseprite/skia/releases/download/m124-08a5439a6b/Skia-macOS-Release-x64.zip"
      sha256 "c11c5fbfa3f8cdefa2255d37cdd1eca823d195ff61929f457a4714f1b6db500a"
    end
  end

  def install
    resource("skia").stage(buildpath/"skia")

    skia_arch = Hardware::CPU.arm? ? "arm64" : "x64"
    osx_arch = Hardware::CPU.arm? ? "arm64" : "x86_64"

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
           "-DCMAKE_BUILD_TYPE=RelWithDebInfo",
           "-DCMAKE_OSX_ARCHITECTURES=#{osx_arch}",
           "-DENABLE_UI=ON",
           "-DLAF_BACKEND=skia",
           "-DSKIA_DIR=#{buildpath}/skia",
           "-DSKIA_LIBRARY_DIR=#{buildpath}/skia/out/Release-#{skia_arch}",
           "-DSKIA_LIBRARY=#{buildpath}/skia/out/Release-#{skia_arch}/libskia.a"
    system "ninja", "-C", "build", "aseprite"

    install_icons(buildpath/"build/bin/Aseprite.app/Contents/Resources")
    prefix.install "build/bin/Aseprite.app"
    bin.write_exec_script prefix/"Aseprite.app/Contents/MacOS/aseprite"
  end

  def icon_sets
    {
      "Aseprite" => {
        "icon_16x16.png"      => "ase16.png",
        "icon_16x16@2x.png"   => "ase32.png",
        "icon_32x32.png"      => "ase32.png",
        "icon_32x32@2x.png"   => "ase64.png",
        "icon_128x128.png"    => "ase128.png",
        "icon_128x128@2x.png" => "ase256.png",
        "icon_256x256.png"    => "ase256.png",
        "icon_256x256@2x.png" => "hd/asehd.png",
        "icon_512x512.png"    => "hd/asehd.png",
      },
      "Document" => {
        "icon_16x16.png"      => "doc16.png",
        "icon_16x16@2x.png"   => "doc32.png",
        "icon_32x32.png"      => "doc32.png",
        "icon_32x32@2x.png"   => "doc64.png",
        "icon_128x128.png"    => "doc128.png",
        "icon_128x128@2x.png" => "doc256.png",
        "icon_256x256.png"    => "doc256.png",
      },
    }
  end

  def install_icons(resources)
    icon_sets.each do |name, images|
      iconset = buildpath/"icons/#{name}.iconset"
      iconset.mkpath
      images.each { |target, source| cp buildpath/"data/icons"/source, iconset/target }
      system "iconutil", "-c", "icns", iconset, "-o", resources/"#{name}.icns"
    end
  end

  def caveats
    <<~EOS
      Aseprite was built from source and the app bundle lives in the Cellar.
      Open the editor with:
        open "#{opt_prefix}/Aseprite.app"
      The `aseprite` command on your PATH runs the same binary for batch and
      command-line use.
    EOS
  end

  test do
    assert_match version.to_s, (prefix/"Aseprite.app/Contents/Info.plist").read
    assert_predicate prefix/"Aseprite.app/Contents/MacOS/aseprite", :executable?
    assert_path_exists prefix/"Aseprite.app/Contents/Resources/Aseprite.icns"
    assert_path_exists prefix/"Aseprite.app/Contents/Resources/Document.icns"
  end
end
