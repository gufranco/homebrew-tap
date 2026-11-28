# frozen_string_literal: true

require "test_helper"

class Rpcs3Test < Minitest::Test
  CASK = File.expand_path("../../Casks/rpcs3.rb", __dir__).freeze
  BUILD_DOWNLOAD = "/releases/download/build-\#{version.csv.second}/rpcs3-v\#{version.csv.first}-" \
                   "\#{version.csv.third}_macos"
  REPOSITORIES = ["RPCS3/rpcs3-binaries-mac-arm64/", "RPCS3/rpcs3-binaries-mac/"].freeze
  VERSION = /\A\d+\.\d+\.\d+-\d+,(\h{40}),(\h{8})\z/

  def test_each_architecture_names_its_own_build_number_full_commit_and_short_commit
    # Arrange
    text = File.read(CASK)

    # Act
    versions = text.scan(Regexp.new('^    version "([^"]+)"$')).flatten

    # Assert
    assert_equal 2, versions.size
    assert_nil text[/^  version /]
    versions.each do |version|
      commit, short = version.match(VERSION)&.captures
      assert_equal commit.to_s[0, 8], short, version
    end
  end

  def test_each_architecture_downloads_the_build_of_that_commit_from_its_own_repository
    # Arrange
    urls = File.read(CASK).scan(Regexp.new('^    url "([^"]+/releases/download/[^"]+)"')).flatten

    # Act
    repositories = REPOSITORIES.select { |repository| urls.any? { |url| url.include?("#{repository}releases") } }

    # Assert
    assert_equal 2, urls.size
    assert_equal([], urls.reject { |url| url.include?(BUILD_DOWNLOAD) })
    assert_equal REPOSITORIES, repositories
  end

  def test_the_livecheck_reads_the_repository_of_the_architecture_it_runs_for
    # Arrange
    text = File.read(CASK)

    # Act
    livecheck = text[/^  livecheck do\n(.*?)^  end$/m, 1]

    # Assert
    assert_match(/^    url :url$/, livecheck)
    assert_match(/\#\{commit\[0, 8\]\}/, livecheck)
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
