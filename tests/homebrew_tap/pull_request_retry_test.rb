# frozen_string_literal: true

require "stringio"
require "test_helper"
require "support/github_fixture"
require "homebrew_tap/github_cli"
require "homebrew_tap/pull_request_retry"

class PullRequestRetryTest < Minitest::Test
  PARALLEL_RETRIES = 10

  def setup
    @github = GitHubFixture.new
    @out = StringIO.new
  end

  def teardown
    @github.remove
  end

  def test_reruns_the_cancelled_jobs_of_a_bot_pull_request
    # Arrange
    run = @github.workflow_run
    @github.open_pull(checks: [@github.check_run("lint", run:),
                               @github.check_run("test", conclusion: "CANCELLED", run:)])

    # Act
    retrier.retry_cancelled

    # Assert
    assert_equal [run], @github.reruns
    assert_equal "reran the cancelled jobs of run #{run} for pull request 1\n", @out.string
  end

  def test_reruns_each_cancelled_run_once_when_several_of_its_jobs_were_cancelled
    # Arrange
    first = @github.workflow_run
    second = @github.workflow_run
    checks = [@github.check_run("style", conclusion: "CANCELLED", run: first),
              @github.check_run("test", conclusion: "CANCELLED", run: first),
              @github.check_run("audit", conclusion: "CANCELLED", run: second)]
    @github.open_pull(checks:)

    # Act
    retrier.retry_cancelled

    # Assert
    assert_equal [first, second], @github.reruns
  end

  def test_leaves_a_failed_check_for_a_person_to_read
    # Arrange
    run = @github.workflow_run
    @github.open_pull(checks: [@github.check_run("test", conclusion: "FAILURE", run:)])

    # Act
    retrier.retry_cancelled

    # Assert
    assert_equal [], @github.reruns
    assert_equal "pull request 1 has no cancelled checks\n", @out.string
  end

  def test_leaves_pull_requests_a_person_opened_or_a_fork_sent
    # Arrange
    run = @github.workflow_run
    cancelled = [@github.check_run("test", conclusion: "CANCELLED", run:)]
    @github.open_pull(checks: cancelled, author: Faker::Internet.username(separators: ["-"]))
    @github.open_pull(checks: cancelled, "isCrossRepository" => true)

    # Act
    retrier.retry_cancelled

    # Assert
    assert_equal [], @github.reruns
    assert_equal "no open bot pull requests\n", @out.string
  end

  def test_stops_with_a_warning_after_the_last_attempt
    # Arrange
    run = @github.workflow_run(attempt: HomebrewTap::PullRequestRetry::MAX_ATTEMPTS)
    @github.open_pull(checks: [@github.check_run("test", conclusion: "CANCELLED", run:)])

    # Act
    retrier.retry_cancelled

    # Assert
    assert_equal [], @github.reruns
    assert_equal "::warning::run #{run} of pull request 1 was cancelled on all 3 attempts\n", @out.string
  end

  def test_leaves_a_run_that_is_already_running_again
    # Arrange
    run = @github.workflow_run(attempt: 2, status: "in_progress")
    @github.open_pull(checks: [@github.check_run("test", conclusion: "CANCELLED", run:)])

    # Act
    retrier.retry_cancelled

    # Assert
    assert_equal [], @github.reruns
    assert_equal "run #{run} of pull request 1 is already running again\n", @out.string
  end

  def test_reports_a_rerun_another_sweep_started_first
    # Arrange
    run = @github.workflow_run("rerunRefused" => true, "startedElsewhere" => true)
    @github.open_pull(checks: [@github.check_run("test", conclusion: "CANCELLED", run:)])

    # Act
    retrier.retry_cancelled

    # Assert
    assert_equal [], @github.reruns
    assert_equal "run #{run} of pull request 1 is already running again\n", @out.string
  end

  def test_raises_when_github_refuses_the_rerun
    # Arrange
    run = @github.workflow_run("rerunRefused" => true)
    @github.open_pull(checks: [@github.check_run("test", conclusion: "CANCELLED", run:)])

    # Act
    error = assert_raises(HomebrewTap::Error) { retrier.retry_cancelled }

    # Assert
    assert_equal "gh run rerun failed: run #{run} cannot be rerun", error.message
    assert_equal [], @github.reruns
  end

  def test_parallel_identical_retries_rerun_exactly_once
    # Arrange
    run = @github.workflow_run
    @github.open_pull(checks: [@github.check_run("test", conclusion: "CANCELLED", run:)])
    outs = Array.new(PARALLEL_RETRIES) { StringIO.new }

    # Act
    outs.map { |out| Thread.new { retrier(out).retry_cancelled } }.each(&:join)

    # Assert
    allowed = ["reran the cancelled jobs of run #{run} for pull request 1\n",
               "run #{run} of pull request 1 is already running again\n"]
    assert_equal [run], @github.reruns
    assert_equal [], outs.map(&:string) - allowed
    assert_equal 1, outs.count { |out| out.string.start_with?("reran") }
  end

  def test_a_second_retry_of_the_same_run_changes_nothing
    # Arrange
    run = @github.workflow_run
    @github.open_pull(checks: [@github.check_run("test", conclusion: "CANCELLED", run:)])
    retrier(StringIO.new).retry_cancelled

    # Act
    retrier.retry_cancelled

    # Assert
    assert_equal [run], @github.reruns
    assert_equal({ "attempt" => 2, "status" => "queued" }, @github.run_state(run))
    assert_equal "run #{run} of pull request 1 is already running again\n", @out.string
  end

  def test_rejects_a_repository_that_is_not_owner_and_name
    # Arrange
    repo = Faker::Internet.slug(glue: "-")

    # Act
    error = assert_raises(HomebrewTap::Error) { retrier(repo:) }

    # Assert
    assert_equal "repository #{repo} is not owner/name", error.message
  end

  private

  def retrier(out = @out, repo: @github.repo)
    HomebrewTap::PullRequestRetry.new(repo:, github: HomebrewTap::GitHubCli.new(command: @github.command), out:)
  end
end
