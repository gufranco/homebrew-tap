# frozen_string_literal: true

require "fileutils"
require "open3"
require "rbconfig"
require "tmpdir"
require "test_helper"
require "support/git_fixture"
require "support/tap_fixture"

class RakeTasksTest < Minitest::Test
  RAKEFILE = File.expand_path("../Rakefile", __dir__).freeze

  def test_formula_bump_points_the_formula_at_the_release
    # Arrange
    tap = TapFixture.new
    tap.write_formula(tag: "v1.0.0")
    tap.publish_release(tag: "v1.1.0", files: { "lib/core.sh" => 'SAMPLE_VERSION="1.1.0"' })
    env = { "NAME" => tap.name, "TAG" => "v1.1.0", "TAP_ARCHIVE_BASE" => tap.archive_base }

    # Act
    out, err, status = rake("formula:bump", env:, dir: tap.root)

    # Assert
    assert_equal ["", 0], [err, status.exitstatus]
    assert_includes out, "formula #{tap.name} now points at v1.1.0\n"
    assert_includes tap.formula_text, "#{tap.archive_base}/gufranco/#{tap.name}/archive/refs/tags/v1.1.0.tar.gz"
  ensure
    tap.remove
  end

  def test_formula_bump_stops_with_the_reason_when_the_tag_is_missing
    # Arrange
    env = { "NAME" => Faker::Internet.slug(glue: "-"), "TAG" => "" }

    # Act
    _out, err, status = rake("formula:bump", env:, dir: Dir.pwd)

    # Assert
    assert_equal 1, status.exitstatus
    assert_equal "homebrew-tap: tag required\n", err
  end

  def test_formula_publish_pushes_the_bump_to_main
    # Arrange
    name = Faker::Internet.slug(glue: "-")
    git = GitFixture.new(formula: name, text: Faker::Lorem.paragraph)
    work = git.clone("work")
    File.write(File.join(work, "Formula", "#{name}.rb"), Faker::Lorem.paragraph)

    # Act
    out, _err, status = rake("formula:publish", env: { "NAME" => name, "TAG" => "v2.0.0" }, dir: work)

    # Assert
    assert_equal 0, status.exitstatus
    assert_equal "pushed Formula/#{name}.rb at v2.0.0 to main\n", out
    assert_equal "chore(formula): point #{name} at v2.0.0", git.subjects.first
  ensure
    git.remove
  end

  def test_hooks_installs_a_pre_commit_hook_that_runs_lint_and_tests
    # Arrange
    dir = Dir.mktmpdir("homebrew-tap-hooks")
    Open3.capture2e("git", "-C", dir, "init", "--quiet")

    # Act
    _out, _err, status = rake("hooks", env: {}, dir:)

    # Assert
    hook = File.join(dir, ".git", "hooks", "pre-commit")
    assert_equal 0, status.exitstatus
    assert_equal "#!/bin/sh\nexec bundle exec rake lint test\n", File.read(hook)
    assert File.executable?(hook)
  ensure
    FileUtils.rm_rf(dir)
  end

  private

  def rake(task, env:, dir:)
    Open3.capture3(env, RbConfig.ruby, Gem.bin_path("rake", "rake"), "--silent", "-f", RAKEFILE, task, chdir: dir)
  end
end
