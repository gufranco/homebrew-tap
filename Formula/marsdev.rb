# frozen_string_literal: true

class Marsdev < Formula
  desc "Sega Mega Drive toolchain: GCC for the 68000 with SGDK, laid out as Marsdev"
  homepage "https://github.com/andwn/marsdev"
  url "https://github.com/andwn/marsdev/archive/3318d3f39823154b24ce48bfa5d8fe6e3f6cde3f.tar.gz"
  version "1.0.0-rc1.20260305"
  sha256 "344a66715f0b543fcb4568442112feca67b7a236e8fc1ab040ea77e96b0e7df1"
  license all_of: ["MIT", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://github.com/andwn/marsdev.git"
    regex(/^v(\d+(?:\.\d+)+(?:-rc\d+)?)$/i)
  end

  depends_on "texinfo" => :build
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "openjdk"
  depends_on "zstd"

  uses_from_macos "zlib"

  resource "binutils" do
    url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.44.tar.xz"
    mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.44.tar.xz"
    sha256 "ce2017e059d63e67ddb9240e9d4ec49c2893605035cd60e92ad53177f4377237"
  end

  resource "gcc" do
    url "https://ftpmirror.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
    mirror "https://ftp.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
    sha256 "438fd996826b0c82485a29da03a72d71d6e3541a83ec702df4271f6fe025d24e"
  end

  resource "sgdk" do
    url "https://github.com/Stephane-D/SGDK/archive/cb114acadc454440fcddd616d9a7dd5a693b1b13.tar.gz"
    sha256 "587b8d46903908f331d13b98c9e3322791d2c089f5181979d2ef99a138ac421b"
  end

  resource "sjasm" do
    url "https://github.com/konamiman/sjasm/archive/refs/tags/v0.39j.tar.gz"
    sha256 "1b8d1fb40acb26ce01f39d2ce0072c894589fa2bae22cbeccf292c104f289f85"
  end

  def install
    build_binutils
    build_gcc
    install_sgdk
    build_libmd
    write_environment
  end

  def caveats
    <<~EOS
      Set MARSDEV and GDK and put the 68000 toolchain on PATH with:
        source #{opt_libexec}/mars/mars.sh
      Build an SGDK project from its folder with:
        make -f $GDK/makefile.gen
    EOS
  end

  test do
    (testpath/"src/main.c").write <<~C
      #include <genesis.h>

      int main(bool hard_reset)
      {
          VDP_drawText(hard_reset ? "cold" : "warm", 1, 1);
          while (TRUE) SYS_doVBlankProcess();
          return 0;
      }
    C
    system "make", "-f", "#{opt_libexec}/mars/m68k-elf/makefile.gen"
    assert_equal "SEGA", (testpath/"out/release/rom.bin").binread(4, 0x100)
    assert_equal "15.2.0", shell_output("#{opt_libexec}/mars/m68k-elf/bin/m68k-elf-gcc -dumpversion").strip
  end

  private

  def gdk
    libexec/"mars/m68k-elf"
  end

  def toolchain_args
    [
      "--target=m68k-elf",
      "--with-cpu=m68000",
      "--prefix=#{gdk}",
      "--libdir=#{gdk}/lib",
      "--libexecdir=#{gdk}/libexec",
      "--disable-nls",
      "--disable-werror",
      "--with-system-zlib",
    ]
  end

  def build_binutils
    resource("binutils").stage do
      mkdir "build" do
        system "../configure", *toolchain_args, "--enable-install-libbfd", "--enable-shared=no"
        system "make"
        system "make", "install-strip"
      end
    end
  end

  def build_gcc
    resource("gcc").stage do
      mkdir "build" do
        system "../configure", *toolchain_args,
               "--enable-languages=c", "--without-headers", "--disable-libssp", "--disable-threads",
               "--disable-tls", "--disable-multilib", "--enable-shared=no",
               "--with-gmp=#{formula_opt_prefix("gmp")}", "--with-mpfr=#{formula_opt_prefix("mpfr")}",
               "--with-mpc=#{formula_opt_prefix("libmpc")}", "--with-isl=#{formula_opt_prefix("isl")}"
        system "make"
        system "make", "install-strip"
      end
    end
  end

  def install_sgdk
    sgdk = buildpath/"sgdk-source"
    resource("sgdk").stage(sgdk)
    cp buildpath/"sgdk/common.mk", sgdk/"common.mk"
    inreplace [sgdk/"inc/snd/pcm/snd_pcm.h", sgdk/"inc/snd/pcm/snd_pcm4.h"], "const bool loop", "const u8 loop"
    (sgdk/"makelib.gen").append_lines \
      "$(addprefix $(OUT_DIR)/, $(SRC_LIB_C:.c=.o)): | $(addprefix $(OUT_DIR)/, $(RES_LIB_RES:.res=.o))"
    cp_r [sgdk/"inc", sgdk/"res", sgdk/"src"], gdk
    cp [sgdk/"common.mk", sgdk/"makelib.gen", sgdk/"makefile.gen", sgdk/"md.ld"], gdk
    inreplace gdk/"common.mk", "JAVA := java", "JAVA := #{formula_opt_bin("openjdk")}/java"
    install_sgdk_tools(sgdk)
  end

  def install_sgdk_tools(sgdk)
    tools = gdk/"bin"
    system ENV.cc, sgdk/"tools/bintos/src/bintos.c", "-o", tools/"bintos"
    cd sgdk/"tools/xgmtool/src" do
      system ENV.cc, *Dir["*.c"], "-I../inc", "-lm", "-o", tools/"xgmtool"
    end
    %w[rescomp xgmRomBuilder sizebnd lz4w apj xgm2tool].each { |jar| cp sgdk/"bin/#{jar}.jar", tools }
    resource("sjasm").stage do
      cd "Sjasm" do
        system "make"
        cp "sjasm", tools
      end
    end
  end

  def build_libmd
    cd gdk do
      system "make", "-f", "makelib.gen", "release"
      system "make", "-f", "makelib.gen", "debug"
      system "make", "-f", "makelib.gen", "clean-task"
    end
  end

  def write_environment
    (libexec/"mars/mars.sh").write <<~SH
      export MARSDEV="#{opt_libexec}/mars"
      export GDK="#{opt_libexec}/mars/m68k-elf"
      export PATH="$PATH:#{opt_libexec}/mars/m68k-elf/bin"
    SH
  end
end
