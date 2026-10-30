# frozen_string_literal: true

require_relative "error"
require_relative "git"

module HomebrewTap
  class TapCheckout
    def initialize(workspace:, tap:)
      @workspace = workspace
      @tap = tap
      freeze
    end

    def verify
      require_installed_tap
      return if same_directory? || same_clean_commit?

      raise Error, "brew audits the tap at #{@tap}, which is not this checkout at the same clean commit. " \
                   "bring both to one commit with no local changes, then audit again."
    end

    def sync
      require_installed_tap
      return if same_directory?

      tap = Git.new(dir: @tap)
      raise Error, "the tap at #{@tap} has local changes. commit or stash them, then sync again." unless clean?(tap)

      tap.run("fetch", "--quiet", @workspace, "HEAD")
      return if tap.ok?("merge", "--quiet", "--ff-only", "FETCH_HEAD")

      raise Error, "the tap at #{@tap} has commits this checkout lacks. reset it to origin/main, then sync again."
    end

    private

    def require_installed_tap
      return if File.directory?(@tap)

      raise Error, "the tap is not installed at #{@tap}. run 'brew tap gufranco/tap' first."
    end

    def same_directory?
      File.realpath(@workspace) == File.realpath(@tap)
    end

    def same_clean_commit?
      workspace = Git.new(dir: @workspace)
      tap = Git.new(dir: @tap)
      head(workspace) == head(tap) && clean?(workspace) && clean?(tap)
    end

    def head(git)
      git.run("rev-parse", "HEAD")
    end

    def clean?(git)
      git.run("status", "--porcelain").empty?
    end
  end
end
