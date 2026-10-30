# frozen_string_literal: true

require "stringio"
require "test_helper"
require "support/github_fixture"
require "homebrew_tap/github_cli"
require "homebrew_tap/pull_request_merge"

class PullRequestMergeTest < Minitest::Test
  PARALLEL_MERGES = 10

  def setup
    @github = GitHubFixture.new
    @out = StringIO.new
  end

  def teardown
    @github.remove
  end

  def test_squash_merges_a_tap_bot_pull_request_whose_checks_all_passed
    # Arrange
    pull = @github.open_pull(checks: [@github.check_run("ci"), @github.check_run("upstream")])

    # Act
    merger.merge(branch: pull["headRefName"], head_sha: pull["headRefOid"])

    # Assert
    expected = { "number" => pull["number"], "subject" => "chore: bump #{pull["title"]} (#1)",
                 "body" => "Merged after every check passed on #{pull["headRefOid"]}.", "squash" => true }
    assert_equal [expected], @github.merges
    assert_equal "merged pull request 1 at #{pull["headRefOid"]}\n", @out.string
  end

  def test_keeps_the_conventional_title_of_a_dependabot_pull_request
    # Arrange
    title = "ci: bump the actions group with #{Faker::Number.between(from: 2, to: 9)} updates"
    pull = @github.open_pull(checks: [@github.check_run("ci")], author: "app/dependabot", title:)

    # Act
    merger.merge(branch: pull["headRefName"], head_sha: pull["headRefOid"])

    # Assert
    assert_equal ["#{title} (#1)"], @github.merges.map { |merge| merge["subject"] }
  end

  def test_counts_skipped_and_neutral_checks_and_successful_statuses_as_passed
    # Arrange
    checks = [@github.check_run("ci", conclusion: "SKIPPED"), @github.check_run("build", conclusion: "NEUTRAL"),
              @github.status_context("renovate")]
    pull = @github.open_pull(checks:)

    # Act
    merger.merge(branch: pull["headRefName"], head_sha: pull["headRefOid"])

    # Assert
    assert_equal [1], @github.merges.map { |merge| merge["number"] }
  end

  def test_waits_while_a_check_is_still_running_or_failed
    # Arrange
    checks = [@github.check_run("ci"), @github.check_run("upstream", conclusion: "", status: "IN_PROGRESS"),
              @github.status_context("renovate", state: "FAILURE")]
    pull = @github.open_pull(checks:)

    # Act
    merger.merge(branch: pull["headRefName"], head_sha: pull["headRefOid"])

    # Assert
    assert_equal [], @github.merges
    assert_equal "pull request 1 has checks not passed yet: upstream, renovate\n", @out.string
  end

  def test_waits_for_a_pull_request_with_no_checks_yet
    # Arrange
    pull = @github.open_pull(checks: [])

    # Act
    merger.merge(branch: pull["headRefName"], head_sha: pull["headRefOid"])

    # Assert
    assert_equal [], @github.merges
    assert_equal "pull request 1 has no checks yet\n", @out.string
  end

  def test_leaves_a_pull_request_a_person_opened
    # Arrange
    author = Faker::Internet.username(separators: ["-"])
    pull = @github.open_pull(checks: [@github.check_run("ci")], author:)

    # Act
    merger.merge(branch: pull["headRefName"], head_sha: pull["headRefOid"])

    # Assert
    assert_equal [], @github.merges
    assert_equal "pull request 1 is by #{author}, not a bot this tap merges\n", @out.string
  end

  def test_leaves_a_pull_request_that_moved_past_the_checked_commit
    # Arrange
    pull = @github.open_pull(checks: [@github.check_run("ci")])
    checked = Faker::Crypto.sha1

    # Act
    merger.merge(branch: pull["headRefName"], head_sha: checked)

    # Assert
    assert_equal [], @github.merges
    assert_equal "pull request 1 moved past #{checked}\n", @out.string
  end

  def test_merges_the_bot_pull_request_when_a_fork_reuses_its_branch_name
    # Arrange
    fork = @github.open_pull(checks: [@github.check_run("ci")], author: Faker::Internet.username(separators: ["-"]),
                             "isCrossRepository" => true)
    bot = @github.open_pull(checks: [@github.check_run("ci")], "headRefName" => fork["headRefName"])

    # Act
    merger.merge(branch: bot["headRefName"], head_sha: bot["headRefOid"])

    # Assert
    assert_equal [bot["number"]], @github.merges.map { |merge| merge["number"] }
  end

  def test_ignores_a_fork_pull_request_on_a_branch_name_the_bot_uses
    # Arrange
    fork = @github.open_pull(checks: [@github.check_run("ci")], "isCrossRepository" => true)

    # Act
    merger.merge(branch: fork["headRefName"], head_sha: fork["headRefOid"])

    # Assert
    assert_equal [], @github.merges
    assert_equal "no open pull request for #{fork["headRefName"]}\n", @out.string
  end

  def test_reports_a_branch_with_no_open_pull_request
    # Arrange
    branch = "bump-#{Faker::Internet.slug(glue: "-")}"

    # Act
    merger.merge(branch:, head_sha: Faker::Crypto.sha1)

    # Assert
    assert_equal "no open pull request for #{branch}\n", @out.string
  end

  def test_reports_a_pull_request_another_run_merged_first
    # Arrange
    pull = @github.open_pull(checks: [@github.check_run("ci")], "mergedElsewhere" => true)

    # Act
    merger.merge(branch: pull["headRefName"], head_sha: pull["headRefOid"])

    # Assert
    assert_equal [], @github.merges
    assert_equal "pull request 1 was already merged\n", @out.string
  end

  def test_raises_when_github_refuses_the_merge
    # Arrange
    pull = @github.open_pull(checks: [@github.check_run("ci")], "conflicting" => true)

    # Act
    error = assert_raises(HomebrewTap::Error) do
      merger.merge(branch: pull["headRefName"], head_sha: pull["headRefOid"])
    end

    # Assert
    assert_equal "gh pr merge failed: Pull request is not mergeable: the merge commit cannot be cleanly created.",
                 error.message
    assert_equal [], @github.merges
  end

  def test_parallel_identical_merges_merge_exactly_once
    # Arrange
    pull = @github.open_pull(checks: [@github.check_run("ci")])
    outs = Array.new(PARALLEL_MERGES) { StringIO.new }

    # Act
    outs.map { |out| Thread.new { merger(out).merge(branch: pull["headRefName"], head_sha: pull["headRefOid"]) } }
        .each(&:join)

    # Assert
    allowed = ["merged pull request 1 at #{pull["headRefOid"]}\n", "pull request 1 was already merged\n",
               "no open pull request for #{pull["headRefName"]}\n"]
    assert_equal 1, @github.merges.size
    assert_equal [], outs.map(&:string) - allowed
    assert_equal 1, outs.count { |out| out.string.start_with?("merged") }
  end

  def test_a_second_merge_of_the_same_pull_request_changes_nothing
    # Arrange
    pull = @github.open_pull(checks: [@github.check_run("ci")])
    merger(StringIO.new).merge(branch: pull["headRefName"], head_sha: pull["headRefOid"])

    # Act
    merger.merge(branch: pull["headRefName"], head_sha: pull["headRefOid"])

    # Assert
    assert_equal 1, @github.merges.size
    assert_equal "no open pull request for #{pull["headRefName"]}\n", @out.string
  end

  def test_rejects_a_repository_that_is_not_owner_and_name
    # Arrange
    repo = Faker::Internet.slug(glue: "-")

    # Act
    error = assert_raises(HomebrewTap::Error) { merger(repo:) }

    # Assert
    assert_equal "repository #{repo} is not owner/name", error.message
  end

  def test_rejects_a_missing_branch_or_head_commit
    # Arrange
    sha = Faker::Crypto.sha1

    # Act
    errors = [["", sha], ["main", ""], ["main", sha[0, 7]]].map do |branch, head_sha|
      assert_raises(HomebrewTap::Error) { merger.merge(branch:, head_sha:) }.message
    end

    # Assert
    assert_equal ["branch required", "head commit required", "head commit #{sha[0, 7]} is not a full commit SHA"],
                 errors
  end

  private

  def merger(out = @out, repo: @github.repo)
    HomebrewTap::PullRequestMerge.new(repo:, github: HomebrewTap::GitHubCli.new(command: @github.command), out:)
  end
end
