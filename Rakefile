# frozen_string_literal: true

require "open3"
require_relative "lib/homebrew_tap/formula_bump"
require_relative "lib/homebrew_tap/formula_publisher"
require_relative "lib/homebrew_tap/github_cli"
require_relative "lib/homebrew_tap/pull_request_merge"
require_relative "lib/homebrew_tap/release"
require_relative "lib/homebrew_tap/tap_checkout"

TAP = "gufranco/tap"
GITHUB = "https://github.com"
AUDIT_SKIPS = ["livecheck_version", "livecheck_https_availability"].freeze

def release_from_env
  HomebrewTap::Release.new(name: ENV.fetch("NAME", ""), tag: ENV.fetch("TAG", ""))
end

def reporting_errors
  yield
rescue HomebrewTap::Error => e
  abort("homebrew-tap: #{e.message}")
end

def command_output(*command)
  output, status = Open3.capture2(*command)
  abort("homebrew-tap: #{command.join(" ")} failed") unless status.success?

  output.strip
end

desc "Run the Minitest suite with a 100% line and branch coverage gate"
task :test do
  loader = "files = ARGV.dup; ARGV.clear; files.each { |file| require File.expand_path(file) }"
  ruby "-w", "-Ilib", "-Itests", "-e", loader, *FileList["tests/**/*_test.rb"]
end

def tap_checkout
  HomebrewTap::TapCheckout.new(workspace: Dir.pwd, tap: command_output("brew", "--repository", TAP))
end

namespace :tap do
  desc "Fast-forward the installed gufranco/tap clone to the HEAD of this checkout"
  task :sync do
    reporting_errors { tap_checkout.sync }
  end
end

desc "Check every formula, cask and Ruby file of the installed tap with Homebrew's tap style rules"
task style: "tap:sync" do
  sh "brew", "style", TAP
end

desc "Lint the workflows with actionlint and every YAML file with yamllint"
task :lint do
  sh "actionlint"
  sh "yamllint", "--strict", "."
end

desc "Audit every formula and cask online with the strict rules"
task audit: "tap:sync" do
  reporting_errors { tap_checkout.verify }
  sh "brew", "audit", "--strict", "--online", "--except=#{AUDIT_SKIPS.join(",")}", "--tap", TAP
end

namespace :formula do
  desc "Point Formula/NAME.rb at the release TAG of gufranco/NAME"
  task :bump do
    reporting_errors do
      bump = HomebrewTap::FormulaBump.new(
        formula_dir:  File.join(Dir.pwd, "Formula"),
        archive_base: ENV.fetch("TAP_ARCHIVE_BASE", GITHUB),
        out:          $stdout,
      )
      bump.bump(release_from_env)
    end
  end

  desc "Build Formula/NAME.rb from source and run its test block"
  task :verify do
    name = ENV.fetch("NAME", "")
    abort("homebrew-tap: NAME must be a formula name, got: #{name}") unless HomebrewTap::Release::NAME.match?(name)
    sh "brew", "install", "--build-from-source", "--formula", "#{TAP}/#{name}"
    sh "brew", "test", "#{TAP}/#{name}"
  end

  desc "Commit Formula/NAME.rb as the tap bot and push it to main"
  task :publish do
    reporting_errors do
      HomebrewTap::FormulaPublisher.new(repo_dir: Dir.pwd, branch: "main", out: $stdout).publish(release_from_env)
    end
  end
end

namespace :pr do
  desc "Squash-merge the bot pull request on BRANCH once every check on HEAD_SHA passed"
  task :merge do
    reporting_errors do
      github = HomebrewTap::GitHubCli.new
      merge = HomebrewTap::PullRequestMerge.new(repo: ENV.fetch("REPO", ""), github:, out: $stdout)
      merge.merge(branch: ENV.fetch("BRANCH", ""), head_sha: ENV.fetch("HEAD_SHA", ""))
    end
  end
end

desc "Install a pre-commit hook that runs rake lint and rake test"
task :hooks do
  hooks = command_output("git", "rev-parse", "--git-path", "hooks")
  mkdir_p hooks
  hook = File.join(hooks, "pre-commit")
  File.write(hook, "#!/bin/sh\nexec bundle exec rake lint test\n")
  chmod 0755, hook
end

desc "Run lint, test and style"
task check: [:lint, :test, :style]

task default: :check
