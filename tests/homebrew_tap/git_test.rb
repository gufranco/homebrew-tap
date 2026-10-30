# frozen_string_literal: true

require "fileutils"
require "test_helper"
require "tmpdir"
require "homebrew_tap/git"

class GitTest < Minitest::Test
  def setup
    @dir = Dir.mktmpdir("homebrew-tap-git")
    @git = HomebrewTap::Git.new(dir: @dir)
    @git.run("init", "--quiet", "--initial-branch=main")
  end

  def teardown
    FileUtils.rm_rf(@dir)
  end

  def test_returns_what_the_command_printed
    # Arrange
    branch = "main"

    # Act
    output = @git.run("symbolic-ref", "--short", "HEAD")

    # Assert
    assert_equal "#{branch}\n", output
  end

  def test_raises_with_the_failing_command_and_its_message
    # Arrange
    missing = Faker::Internet.slug(glue: "-")

    # Act
    error = assert_raises(HomebrewTap::Error) { @git.run("rev-parse", "--verify", "--quiet", missing) }

    # Assert
    assert_equal "git rev-parse --verify --quiet #{missing} failed: ", error.message
  end

  def test_answers_whether_a_command_succeeded
    # Arrange
    missing = Faker::Internet.slug(glue: "-")

    # Act
    found = @git.ok?("rev-parse", "--verify", "--quiet", missing)

    # Assert
    refute found
    assert @git.ok?("status")
  end

  def test_runs_with_the_given_environment
    # Arrange
    name = Faker::Name.name
    git = HomebrewTap::Git.new(dir: @dir, env: { "GIT_AUTHOR_NAME" => name })

    # Act
    ident = git.run("var", "GIT_AUTHOR_IDENT")

    # Assert
    assert_equal name, ident.split(" <").first
  end
end
