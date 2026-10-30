# frozen_string_literal: true

require "stringio"
require "test_helper"
require "support/tap_fixture"
require "homebrew_tap/formula_bump"
require "homebrew_tap/release"

class FormulaBumpTest < Minitest::Test
  PARALLEL_BUMPS = 10

  def setup
    @tap = TapFixture.new
    @out = StringIO.new
    @bump = HomebrewTap::FormulaBump.new(formula_dir: @tap.formula_dir, archive_base: @tap.archive_base, out: @out)
  end

  def teardown
    @tap.remove
  end

  def test_fails_when_the_named_formula_does_not_exist
    # Arrange
    release = release("v1.0.0")

    # Act
    error = assert_raises(HomebrewTap::Error) { @bump.bump(release) }

    # Assert
    assert_equal "no formula at #{@tap.formula_path}", error.message
  end

  def test_refuses_a_formula_that_is_not_built_from_the_owners_repository
    # Arrange
    @tap.write_formula(tag: "v1.0.0", homepage: "https://github.com/someone-else/#{@tap.name}")

    # Act
    error = assert_raises(HomebrewTap::Error) { @bump.bump(release("v1.1.0")) }

    # Assert
    assert_equal "formula #{@tap.name} is not built from gufranco/#{@tap.name}", error.message
  end

  def test_fails_when_the_release_archive_cannot_be_downloaded
    # Arrange
    @tap.write_formula(tag: "v1.0.0")

    # Act
    error = assert_raises(HomebrewTap::Error) { @bump.bump(release("v9.9.9")) }

    # Assert
    assert_equal "could not download #{@tap.archive_base}/gufranco/#{@tap.name}/archive/refs/tags/v9.9.9.tar.gz",
                 error.message
  end

  def test_points_the_formula_at_the_new_archive_and_its_checksum
    # Arrange
    @tap.write_formula(tag: "v1.0.0")
    path = @tap.publish_release(tag: "v2.1.0", files: { "lib/core.sh" => 'SAMPLE_VERSION="2.1.0"' })
    url = "#{@tap.archive_base}/gufranco/#{@tap.name}/archive/refs/tags/v2.1.0.tar.gz"

    # Act
    @bump.bump(release("v2.1.0"))

    # Assert
    checksum = Digest::SHA256.file(path).hexdigest
    assert_includes @tap.formula_text, %Q(url "#{url}")
    assert_includes @tap.formula_text, %Q(sha256 "#{checksum}")
    assert_equal "formula #{@tap.name} now points at v2.1.0\n  url:    #{url}\n  sha256: #{checksum}\n", @out.string
  end

  def test_fails_when_the_tag_and_the_code_disagree_on_the_version
    # Arrange
    @tap.write_formula(tag: "v1.0.0")
    @tap.publish_release(tag: "v2.1.0", files: { "lib/core.sh" => 'SAMPLE_VERSION="2.0.9"' })

    # Act
    error = assert_raises(HomebrewTap::Error) { @bump.bump(release("v2.1.0")) }

    # Assert
    assert_equal "the release is tagged v2.1.0 but the code in it says 2.0.9", error.message
    assert_includes @tap.formula_text, @tap.tagged_url("v1.0.0")
  end

  def test_leaves_the_formula_on_a_newer_tag_when_asked_for_an_older_one
    # Arrange
    @tap.write_formula(tag: "v2.1.0")
    before = @tap.formula_text

    # Act
    @bump.bump(release("v2.0.0"))

    # Assert
    assert_equal before, @tap.formula_text
    assert_equal "formula #{@tap.name} already points at v2.1.0, newer than v2.0.0\n", @out.string
  end

  def test_moves_from_a_lower_minor_version_compared_as_a_number
    # Arrange
    @tap.write_formula(tag: "v2.9.0")
    @tap.publish_release(tag: "v2.10.0", files: { "pyproject.toml" => 'version = "2.10.0"' })

    # Act
    @bump.bump(release("v2.10.0"))

    # Assert
    assert_includes @out.string, "formula #{@tap.name} now points at v2.10.0"
  end

  def test_bumping_twice_to_the_same_tag_leaves_one_result
    # Arrange
    @tap.write_formula(tag: "v1.0.0")
    @tap.publish_release(tag: "v1.1.0", files: { "lib/core.sh" => 'SAMPLE_VERSION="1.1.0"' })
    @bump.bump(release("v1.1.0"))
    first = @tap.formula_text

    # Act
    @bump.bump(release("v1.1.0"))

    # Assert
    assert_equal first, @tap.formula_text
  end

  def test_parallel_identical_bumps_leave_one_rewritten_formula
    # Arrange
    @tap.write_formula(tag: "v1.0.0")
    path = @tap.publish_release(tag: "v1.1.0", files: { "lib/core.sh" => 'SAMPLE_VERSION="1.1.0"' })
    bumps = Array.new(PARALLEL_BUMPS) do
      HomebrewTap::FormulaBump.new(formula_dir: @tap.formula_dir, archive_base: @tap.archive_base, out: StringIO.new)
    end

    # Act
    bumps.map { |bump| Thread.new { bump.bump(release("v1.1.0")) } }.each(&:join)

    # Assert
    url = "#{@tap.archive_base}/gufranco/#{@tap.name}/archive/refs/tags/v1.1.0.tar.gz"
    assert_equal @tap.formula_source(url:, sha256: Digest::SHA256.file(path).hexdigest), @tap.formula_text
    assert_equal ["#{@tap.name}.rb"], Dir.children(@tap.formula_dir)
  end

  private

  def release(tag)
    HomebrewTap::Release.new(name: @tap.name, tag:)
  end
end
