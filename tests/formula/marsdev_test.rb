# frozen_string_literal: true

require "test_helper"

class MarsdevTest < Minitest::Test
  FORMULA = File.expand_path("../../Formula/marsdev.rb", __dir__).freeze
  MARSDEV_REVISION = "3318d3f39823154b24ce48bfa5d8fe6e3f6cde3f"
  PINNED_BY_MARSDEV = {
    "binutils-2.44.tar.xz"                                 =>
      "ce2017e059d63e67ddb9240e9d4ec49c2893605035cd60e92ad53177f4377237",
    "gcc-15.2.0.tar.xz"                                    =>
      "438fd996826b0c82485a29da03a72d71d6e3541a83ec702df4271f6fe025d24e",
    "SGDK/archive/cb114acadc454440fcddd616d9a7dd5a693b1b13" => nil,
    "sjasm/archive/refs/tags/v0.39"                        => nil,
  }.freeze

  def test_packages_the_marsdev_revision_it_names
    # Arrange
    text = File.read(FORMULA)

    # Act
    url = text[Regexp.new('^  url "([^"]+)"$'), 1]

    # Assert
    assert_equal "https://github.com/andwn/marsdev/archive/#{MARSDEV_REVISION}.tar.gz", url
  end

  def test_builds_the_sources_that_marsdev_pins_at_that_revision
    # Arrange
    text = File.read(FORMULA)

    # Act
    missing = PINNED_BY_MARSDEV.reject do |source, sha256|
      text.include?(source) && (sha256.nil? || text.include?(%Q(sha256 "#{sha256}")))
    end

    # Assert
    assert_equal({}, missing)
  end

  def test_declares_every_library_the_built_toolchain_links
    # Arrange
    text = File.read(FORMULA)

    # Act
    declared = text.scan(/^  depends_on "([^"]+)"$/).flatten

    # Assert
    assert_equal %w[gmp isl libmpc mpfr openjdk zstd], declared
  end

  def test_keeps_the_toolchain_off_the_shared_bin_folder
    # Arrange
    text = File.read(FORMULA)

    # Act
    linked = text.lines.grep(/\bbin\.(install|write_exec_script|install_symlink)\b/)

    # Assert
    assert_equal [], linked
  end
end
