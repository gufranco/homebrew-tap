# frozen_string_literal: true

require "fileutils"
require "open3"
require "tmpdir"

class GitFixture
  attr_reader :root, :origin

  def initialize(formula:, text:)
    name = Faker::Name.name
    email = Faker::Internet.email
    @person = {
      "GIT_AUTHOR_NAME"     => name,
      "GIT_AUTHOR_EMAIL"    => email,
      "GIT_COMMITTER_NAME"  => name,
      "GIT_COMMITTER_EMAIL" => email,
    }.freeze
    @root = Dir.mktmpdir("homebrew-tap-git")
    @origin = File.join(root, "origin.git")
    git(root, "init", "--quiet", "--bare", "--initial-branch=main", origin)
    seed = clone("seed")
    commit(seed, "Formula/#{formula}.rb", text, "feat(formula): add #{formula}")
  end

  def clone(label)
    path = File.join(root, label)
    git(root, "clone", "--quiet", origin, path)
    path
  end

  def commit(dir, relative, text, message)
    commit_locally(dir, relative, text, message)
    git(dir, "push", "--quiet", "origin", "HEAD:main")
  end

  def commit_locally(dir, relative, text, message)
    FileUtils.mkdir_p(File.dirname(File.join(dir, relative)))
    File.write(File.join(dir, relative), text)
    git(dir, "add", "--", relative)
    git(dir, "commit", "--quiet", "--message", message)
  end

  def subjects
    git(root, "--git-dir", origin, "log", "--format=%s", "main").lines(chomp: true)
  end

  def author_of_tip
    git(root, "--git-dir", origin, "log", "-1", "--format=%an <%ae>", "main").strip
  end

  def reject_every_push
    hook = File.join(origin, "hooks", "pre-receive")
    File.write(hook, "#!/bin/sh\nexit 1\n")
    File.chmod(0755, hook)
  end

  def remove
    FileUtils.rm_rf(root)
  end

  private

  def git(dir, *args)
    output, status = Open3.capture2e(@person, "git", "-C", dir, *args)
    raise "git #{args.join(" ")} failed: #{output}" unless status.success?

    output
  end
end
