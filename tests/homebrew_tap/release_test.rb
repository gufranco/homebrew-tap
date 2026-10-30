# frozen_string_literal: true

require "test_helper"
require "homebrew_tap/release"

class ReleaseTest < Minitest::Test
  def setup
    @name = Faker::Internet.slug(glue: "-")
  end

  def test_rejects_an_empty_formula_name
    # Arrange
    tag = "v1.0.0"

    # Act
    error = assert_raises(HomebrewTap::Error) { HomebrewTap::Release.new(name: "", tag:) }

    # Assert
    assert_equal "formula name required", error.message
  end

  def test_rejects_an_empty_tag
    # Arrange
    name = @name

    # Act
    error = assert_raises(HomebrewTap::Error) { HomebrewTap::Release.new(name:, tag: "") }

    # Assert
    assert_equal "tag required", error.message
  end

  def test_rejects_a_formula_name_that_could_leave_the_formula_folder
    # Arrange
    name = "../#{@name}"

    # Act
    error = assert_raises(HomebrewTap::Error) { HomebrewTap::Release.new(name:, tag: "v1.0.0") }

    # Assert
    assert_equal "formula name ../#{@name} is not a plain lowercase name", error.message
  end

  def test_rejects_a_tag_that_is_not_a_release_version
    # Arrange
    tag = "latest"

    # Act
    error = assert_raises(HomebrewTap::Error) { HomebrewTap::Release.new(name: @name, tag:) }

    # Assert
    assert_equal "tag latest is not a release version", error.message
  end

  def test_names_the_repository_and_homepage_under_the_owner
    # Arrange
    release = HomebrewTap::Release.new(name: @name, tag: "v2.1.0")

    # Act
    homepage = release.homepage

    # Assert
    assert_equal "gufranco/#{@name}", release.repo
    assert_equal "https://github.com/gufranco/#{@name}", homepage
  end

  def test_builds_the_tagged_archive_url_on_the_given_base
    # Arrange
    release = HomebrewTap::Release.new(name: @name, tag: "v2.1.0")

    # Act
    url = release.archive_url("https://github.com")

    # Assert
    assert_equal "https://github.com/gufranco/#{@name}/archive/refs/tags/v2.1.0.tar.gz", url
  end

  def test_reads_the_version_without_the_v_prefix
    # Arrange
    release = HomebrewTap::Release.new(name: @name, tag: "v3.4.5")

    # Act
    version = release.version

    # Assert
    assert_equal "3.4.5", version
  end

  def test_compares_tags_as_versions_rather_than_as_text
    # Arrange
    older = "v2.9.0"

    # Act
    newer = HomebrewTap::Release.version_of("v2.10.0")

    # Assert
    assert_operator newer, :>, HomebrewTap::Release.version_of(older)
  end
end
