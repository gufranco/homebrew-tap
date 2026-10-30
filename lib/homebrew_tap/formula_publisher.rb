# frozen_string_literal: true

require_relative "error"
require_relative "git"

module HomebrewTap
  class FormulaPublisher
    PUSH_ATTEMPTS = 3
    BOT_NAME = "gufranco-tap-bot[bot]"
    BOT_EMAIL = "346559818+gufranco-tap-bot[bot]@users.noreply.github.com"
    IDENTITY = {
      "GIT_AUTHOR_NAME"     => BOT_NAME,
      "GIT_AUTHOR_EMAIL"    => BOT_EMAIL,
      "GIT_COMMITTER_NAME"  => BOT_NAME,
      "GIT_COMMITTER_EMAIL" => BOT_EMAIL,
    }.freeze

    def initialize(repo_dir:, branch:, out:)
      @git = Git.new(dir: repo_dir, env: IDENTITY)
      @branch = branch
      @out = out
      freeze
    end

    def publish(release)
      path = "Formula/#{release.name}.rb"
      @git.run("add", "--", path)
      if @git.ok?("diff", "--cached", "--quiet")
        @out.puts("#{path} already points at #{release.tag}")
      else
        @git.run("commit", "--quiet", "--message", "chore(formula): point #{release.name} at #{release.tag}")
        push
        @out.puts("pushed #{path} at #{release.tag} to #{@branch}")
      end
    end

    private

    def push
      pushed = (1..PUSH_ATTEMPTS).any? { |attempt| pushed_on?(attempt) }
      raise Error, "could not push to #{@branch} after #{PUSH_ATTEMPTS} attempts" unless pushed
    end

    def pushed_on?(attempt)
      return true if @git.ok?("push", "--quiet", "origin", "HEAD:#{@branch}")

      @out.puts("push attempt #{attempt} lost a race, rebasing")
      @git.run("pull", "--quiet", "--rebase", "origin", @branch)
      false
    end
  end
end
