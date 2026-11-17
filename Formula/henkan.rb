# frozen_string_literal: true

class Henkan < Formula
  desc "Convert, verify and store game disc images and game packages"
  homepage "https://github.com/gufranco/henkan"
  url "https://github.com/gufranco/henkan/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "8cf8d8a40cdf26fed9de8fb9ee0e85899fb5fde45633f36bfaccbc5e92bcf512"
  license "MIT"
  head "https://github.com/gufranco/henkan.git", branch: "main"

  depends_on "uv" => :build
  depends_on "python@3.14"

  def install
    python = formula_opt_bin("python@3.14")/"python3.14"
    ENV["UV_PROJECT_ENVIRONMENT"] = libexec
    ENV["UV_PYTHON_DOWNLOADS"] = "never"
    system "uv", "sync", "--frozen", "--no-dev", "--no-editable", "--extra", "cli",
           "--python", python
    bin.install_symlink libexec/"bin/henkan"
  end

  test do
    assert_match "henkan #{version}", shell_output("#{bin}/henkan --version")

    report = shell_output("#{bin}/henkan doctor")
    assert_match "zlib", report
    assert_match "compression.zstd", report

    assert_match '"healthy": true', shell_output("#{bin}/henkan doctor --json")
  end
end
