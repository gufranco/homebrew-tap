# frozen_string_literal: true

require "stringio"
require "test_helper"
require "support/git_fixture"
require "homebrew_tap/formula_publisher"
require "homebrew_tap/release"

class FormulaPublisherTest < Minitest::Test
  PARALLEL_PUBLISHERS = 10

  def setup
    @name = Faker::Internet.slug(glue: "-")
    @old = formula_text("v1.0.0")
    @new = formula_text("v1.1.0")
    @git = GitFixture.new(formula: @name, text: @old)
    @out = StringIO.new
  end

  def teardown
    @git.remove
  end

  def test_pushes_a_changed_formula_as_one_bot_commit
    # Arrange
    work = rewritten_clone("work")

    # Act
    publisher(work).publish(release)

    # Assert
    assert_equal ["chore(formula): point #{@name} at v1.1.0", "feat(formula): add #{@name}"], @git.subjects
    assert_equal "#{HomebrewTap::FormulaPublisher::BOT_NAME} <#{HomebrewTap::FormulaPublisher::BOT_EMAIL}>",
                 @git.author_of_tip
    assert_equal "pushed Formula/#{@name}.rb at v1.1.0 to main\n", @out.string
  end

  def test_makes_no_commit_when_the_formula_is_unchanged
    # Arrange
    work = @git.clone("work")

    # Act
    publisher(work).publish(release)

    # Assert
    assert_equal ["feat(formula): add #{@name}"], @git.subjects
    assert_equal "Formula/#{@name}.rb already points at v1.1.0\n", @out.string
  end

  def test_rebases_and_pushes_again_when_main_moved_first
    # Arrange
    work = rewritten_clone("work")
    @git.commit(@git.clone("other"), "README.md", Faker::Lorem.paragraph, "docs: describe the tap")

    # Act
    publisher(work).publish(release)

    # Assert
    expected = ["chore(formula): point #{@name} at v1.1.0", "docs: describe the tap", "feat(formula): add #{@name}"]
    assert_equal expected, @git.subjects
    assert_includes @out.string, "push attempt 1 lost a race, rebasing\n"
  end

  def test_fails_after_every_push_attempt_is_rejected
    # Arrange
    work = rewritten_clone("work")
    @git.reject_every_push

    # Act
    error = assert_raises(HomebrewTap::Error) { publisher(work).publish(release) }

    # Assert
    assert_equal "could not push to main after 3 attempts", error.message
    assert_equal ["feat(formula): add #{@name}"], @git.subjects
  end

  def test_parallel_identical_publishes_leave_exactly_one_commit
    # Arrange
    clones = Array.new(PARALLEL_PUBLISHERS) { |index| rewritten_clone("work-#{index}") }

    # Act
    clones.map { |work| Thread.new { publisher(work, StringIO.new).publish(release) } }.each(&:join)

    # Assert
    assert_equal ["chore(formula): point #{@name} at v1.1.0", "feat(formula): add #{@name}"], @git.subjects
  end

  def test_a_second_publish_of_the_same_bump_makes_no_commit
    # Arrange
    publisher(rewritten_clone("first"), StringIO.new).publish(release)
    second = rewritten_clone("second")

    # Act
    publisher(second).publish(release)

    # Assert
    assert_equal ["chore(formula): point #{@name} at v1.1.0", "feat(formula): add #{@name}"], @git.subjects
    assert_equal "Formula/#{@name}.rb already points at v1.1.0\n", @out.string
  end

  private

  def release
    HomebrewTap::Release.new(name: @name, tag: "v1.1.0")
  end

  def publisher(work, out = @out)
    HomebrewTap::FormulaPublisher.new(repo_dir: work, branch: "main", out:)
  end

  def rewritten_clone(label)
    work = @git.clone(label)
    File.write(File.join(work, "Formula", "#{@name}.rb"), @new)
    work
  end

  def formula_text(tag)
    "class Sample < Formula\n  url \"https://github.com/gufranco/#{@name}/archive/refs/tags/#{tag}.tar.gz\"\nend\n"
  end
end
