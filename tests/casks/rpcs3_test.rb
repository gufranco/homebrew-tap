# frozen_string_literal: true

require "test_helper"

class Rpcs3Test < Minitest::Test
  CASK = File.expand_path("../../Casks/rpcs3.rb", __dir__).freeze
  BUILD_DOWNLOAD = "/releases/download/build-\#{version.csv.second}/rpcs3-v\#{version.csv.first}-" \
                   "\#{version.csv.second[0, 8]}_macos"
  REPOSITORIES = ["RPCS3/rpcs3-binaries-mac-arm64/", "RPCS3/rpcs3-binaries-mac/"].freeze

  def test_the_version_names_the_build_number_and_the_full_commit
    # Arrange
    text = File.read(CASK)

    # Act
    version = text[Regexp.new('^  version "([^"]+)"$'), 1]

    # Assert
    assert_match(/\A\d+\.\d+\.\d+-\d+,\h{40}\z/, version)
  end

  def test_each_architecture_downloads_the_build_of_that_commit_from_its_own_repository
    # Arrange
    urls = File.read(CASK).scan(Regexp.new('^    url "([^"]+/releases/download/[^"]+)"')).flatten

    # Act
    repositories = REPOSITORIES.select { |repository| urls.any? { |url| url.include?("#{repository}releases") } }

    # Assert
    assert_equal 2, urls.size
    assert(urls.all? { |url| url.include?(BUILD_DOWNLOAD) })
    assert_equal REPOSITORIES, repositories
  end

  def test_requires_the_macos_release_the_build_targets
    # Arrange
    text = File.read(CASK)

    # Act
    requirement = text[/depends_on macos: :(\w+)/, 1]

    # Assert
    assert_equal "sequoia", requirement
  end
end
