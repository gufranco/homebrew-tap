# frozen_string_literal: true

require "json"
require_relative "error"

module HomebrewTap
  class PullRequestMerge
    BOTS = ["app/dependabot", "app/gufranco-tap-bot"].freeze
    PASSED = ["SUCCESS", "NEUTRAL", "SKIPPED"].freeze
    FIELDS = "number,title,author,headRefOid,statusCheckRollup,isCrossRepository"
    OPEN_PULLS_LIMIT = "100"
    REPO = %r{\A[\w.-]+/[\w.-]+\z}
    SHA = /\A[0-9a-f]{40}\z/
    CONVENTIONAL = /\A[a-z]+(\([^)]+\))?!?: /

    def initialize(repo:, github:, out:)
      raise Error, "repository #{repo} is not owner/name" unless REPO.match?(repo)

      @repo = repo
      @github = github
      @out = out
      freeze
    end

    def merge(branch:, head_sha:)
      require_target(branch, head_sha)
      pull = open_pull(branch)
      return @out.puts("no open pull request for #{branch}") unless pull

      settle(pull, head_sha)
    end

    def merge_all
      pulls = open_pulls
      @out.puts("no open pull requests") if pulls.empty?
      pulls.each { |pull| settle(pull, pull["headRefOid"]) }
    end

    private

    def settle(pull, head_sha)
      hold = hold_reason(pull, head_sha)
      return @out.puts(hold) if hold

      squash(pull["number"].to_s, pull["title"], head_sha)
    end

    def open_pulls
      listed = @github.run("pr", "list", "--repo", @repo, "--state", "open", "--limit", OPEN_PULLS_LIMIT,
                           "--json", FIELDS)
      JSON.parse(listed).select { |pull| pull["isCrossRepository"] == false }
    end

    def require_target(branch, head_sha)
      raise Error, "branch required" if branch.empty?
      raise Error, "head commit required" if head_sha.empty?
      raise Error, "head commit #{head_sha} is not a full commit SHA" unless SHA.match?(head_sha)
    end

    def open_pull(branch)
      listed = @github.run("pr", "list", "--repo", @repo, "--head", branch, "--state", "open", "--json", FIELDS)
      JSON.parse(listed).find { |pull| pull["isCrossRepository"] == false }
    end

    def hold_reason(pull, head_sha)
      number = pull["number"]
      author = pull["author"]["login"]
      checks = pull["statusCheckRollup"]
      unpassed = checks.reject { |check| PASSED.include?(check["conclusion"] || check["state"]) }
      return "pull request #{number} is by #{author}, not a bot this tap merges" unless BOTS.include?(author)
      return "pull request #{number} moved past #{head_sha}" if pull["headRefOid"] != head_sha
      return "pull request #{number} has no checks yet" if checks.empty?

      "pull request #{number} has checks not passed yet: #{names(unpassed)}" unless unpassed.empty?
    end

    def names(checks)
      checks.map { |check| check["name"] || check["context"] }.join(", ")
    end

    def squash(number, title, head_sha)
      @github.run("pr", "merge", number, "--repo", @repo, "--squash", "--match-head-commit", head_sha,
                  "--subject", "#{subject(title)} (##{number})",
                  "--body", "Merged after every check passed on #{head_sha}.")
      @out.puts("merged pull request #{number} at #{head_sha}")
    rescue Error
      raise unless merged?(number)

      @out.puts("pull request #{number} was already merged")
    end

    def subject(title)
      CONVENTIONAL.match?(title) ? title : "chore: bump #{title}"
    end

    def merged?(number)
      JSON.parse(@github.run("pr", "view", number, "--repo", @repo, "--json", "state"))["state"] == "MERGED"
    end
  end
end
