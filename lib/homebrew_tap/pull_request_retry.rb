# frozen_string_literal: true

require "json"
require_relative "error"
require_relative "pull_request_merge"

module HomebrewTap
  class PullRequestRetry
    MAX_ATTEMPTS = 3
    CANCELLED = "CANCELLED"
    FIELDS = "number,author,statusCheckRollup,isCrossRepository"
    RUN_ID = %r{/actions/runs/(\d+)/}

    def initialize(repo:, github:, out:)
      raise Error, "repository #{repo} is not owner/name" unless PullRequestMerge::REPO.match?(repo)

      @repo = repo
      @github = github
      @out = out
      freeze
    end

    def retry_cancelled
      pulls = bot_pulls
      @out.puts("no open bot pull requests") if pulls.empty?
      pulls.each { |pull| retry_pull(pull) }
    end

    private

    def bot_pulls
      listed = @github.run("pr", "list", "--repo", @repo, "--state", "open",
                           "--limit", PullRequestMerge::OPEN_PULLS_LIMIT, "--json", FIELDS)
      JSON.parse(listed).select do |pull|
        pull["isCrossRepository"] == false && PullRequestMerge::BOTS.include?(pull["author"]["login"])
      end
    end

    def retry_pull(pull)
      number = pull["number"]
      runs = cancelled_runs(pull["statusCheckRollup"])
      @out.puts("pull request #{number} has no cancelled checks") if runs.empty?
      runs.each { |run| rerun(number, run) }
    end

    def cancelled_runs(checks)
      checks.select { |check| check["conclusion"] == CANCELLED }
            .filter_map { |check| check["detailsUrl"].to_s[RUN_ID, 1] }
            .uniq
    end

    def rerun(number, run)
      found = view(run)
      return already_running(number, run) if running?(found)
      return exhausted(number, run) if found["attempt"] >= MAX_ATTEMPTS

      start(number, run)
    end

    def start(number, run)
      @github.run("run", "rerun", run, "--repo", @repo, "--failed")
      @out.puts("reran the cancelled jobs of run #{run} for pull request #{number}")
    rescue Error
      raise unless running?(view(run))

      already_running(number, run)
    end

    def already_running(number, run)
      @out.puts("run #{run} of pull request #{number} is already running again")
    end

    def exhausted(number, run)
      @out.puts("::warning::run #{run} of pull request #{number} was cancelled on all #{MAX_ATTEMPTS} attempts")
    end

    def view(run)
      JSON.parse(@github.run("run", "view", run, "--repo", @repo, "--json", "attempt,status"))
    end

    def running?(found)
      found["status"] != "completed"
    end
  end
end
