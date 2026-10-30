# frozen_string_literal: true

require "digest"
require "test_helper"
require "support/tap_fixture"
require "homebrew_tap/release_archive"

class ReleaseArchiveTest < Minitest::Test
  def setup
    @tap = TapFixture.new
  end

  def teardown
    @tap.remove
  end

  def test_fails_when_the_archive_cannot_be_downloaded
    # Arrange
    url = "#{@tap.archive_base}/missing.tar.gz"

    # Act
    error = assert_raises(HomebrewTap::Error) { HomebrewTap::ReleaseArchive.download(url) }

    # Assert
    assert_equal "could not download #{url}", error.message
  end

  def test_hashes_the_downloaded_bytes_with_sha256
    # Arrange
    path = @tap.publish_release(tag: "v2.1.0", files: { "lib/core.sh" => 'SAMPLE_VERSION="2.1.0"' })

    # Act
    archive = download("v2.1.0")

    # Assert
    assert_equal Digest::SHA256.file(path).hexdigest, archive.sha256
  end

  def test_reads_the_version_of_a_shell_project_from_lib_core_sh
    # Arrange
    @tap.publish_release(tag: "v2.1.0", files: { "lib/core.sh" => "#!/bin/sh\nSAMPLE_VERSION=\"2.1.0\"\n" })

    # Act
    version = download("v2.1.0").packaged_version

    # Assert
    assert_equal "2.1.0", version
  end

  def test_reads_the_version_of_a_python_project_from_pyproject_toml
    # Arrange
    @tap.publish_release(tag: "v3.4.5", files: { "pyproject.toml" => "[project]\nversion = \"3.4.5\"\n" })

    # Act
    version = download("v3.4.5").packaged_version

    # Assert
    assert_equal "3.4.5", version
  end

  def test_prefers_pyproject_toml_when_both_manifests_are_present
    # Arrange
    files = { "lib/core.sh" => 'SAMPLE_VERSION="1.0.0"', "pyproject.toml" => 'version = "3.0.0"' }
    @tap.publish_release(tag: "v3.0.0", files:)

    # Act
    version = download("v3.0.0").packaged_version

    # Assert
    assert_equal "3.0.0", version
  end

  def test_ignores_a_pyproject_toml_below_the_top_folder
    # Arrange
    files = { "vendor/pyproject.toml" => 'version = "9.9.9"', "lib/core.sh" => 'SAMPLE_VERSION="1.2.0"' }
    @tap.publish_release(tag: "v1.2.0", files:)

    # Act
    version = download("v1.2.0").packaged_version

    # Assert
    assert_equal "1.2.0", version
  end

  def test_reports_an_empty_version_when_the_manifest_names_none
    # Arrange
    @tap.publish_release(tag: "v1.0.0", files: { "pyproject.toml" => "[project]\nname = \"sample\"\n" })

    # Act
    version = download("v1.0.0").packaged_version

    # Assert
    assert_equal "", version
  end

  def test_fails_when_the_archive_has_no_manifest
    # Arrange
    @tap.publish_release(tag: "v2.1.0", files: { "README.md" => Faker::Lorem.paragraph })
    archive = download("v2.1.0")

    # Act
    error = assert_raises(HomebrewTap::Error) { archive.packaged_version }

    # Assert
    expected = "the release archive has neither pyproject.toml nor lib/core.sh to read a version from"
    assert_equal expected, error.message
  end

  def test_fails_when_the_download_is_not_a_gzip_tarball
    # Arrange
    @tap.publish_bytes(tag: "v2.1.0", bytes: Faker::Lorem.paragraph)

    # Act
    error = assert_raises(HomebrewTap::Error) { download("v2.1.0") }

    # Assert
    assert_match(/\Athe release archive is not a gzip tarball: /, error.message)
  end

  private

  def download(tag)
    HomebrewTap::ReleaseArchive.download("file://#{@tap.archive_path(tag)}")
  end
end
