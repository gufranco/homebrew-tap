# frozen_string_literal: true

require "test_helper"
require "support/github_fixture"
require "homebrew_tap/github_cli"

class GitHubCliTest < Minitest::Test
  def setup
    @github = GitHubFixture.new
    @gh = HomebrewTap::GitHubCli.new(command: @github.command)
  end

  def teardown
    @github.remove
  end

  def test_returns_what_the_command_printed
    # Arrange
    pull = @github.open_pull(checks: [])

    # Act
    output = @gh.run("pr", "view", pull["number"].to_s, "--repo", @github.repo, "--json", "state")

    # Assert
    assert_equal %Q({"state":"OPEN"}\n), output
  end

  def test_raises_with_the_subcommand_and_its_error
    # Arrange
    verb = Faker::Lorem.word

    # Act
    error = assert_raises(HomebrewTap::Error) { @gh.run("pr", verb) }

    # Assert
    assert_equal "gh pr #{verb} failed: unknown command: pr #{verb}", error.message
  end
end
