# frozen_string_literal: true

require "test_helper"
require "support/git_fixture"
require "homebrew_tap/tap_checkout"

class TapCheckoutTest < Minitest::Test
  def setup
    @git = GitFixture.new(formula: Faker::Internet.slug(glue: "-"), text: Faker::Lorem.paragraph)
    @workspace = @git.clone("workspace")
  end

  def teardown
    @git.remove
  end

  def test_accepts_a_tap_that_links_to_this_checkout
    # Arrange
    tap = File.join(@git.root, "linked-tap")
    File.symlink(@workspace, tap)

    # Act
    result = checkout(tap).verify

    # Assert
    assert_nil result
  end

  def test_accepts_a_separate_tap_clone_at_the_same_clean_commit
    # Arrange
    tap = @git.clone("tap")

    # Act
    result = checkout(tap).verify

    # Assert
    assert_nil result
  end

  def test_rejects_a_tap_clone_at_another_commit
    # Arrange
    tap = @git.clone("tap")
    @git.commit(@workspace, "README.md", Faker::Lorem.paragraph, "docs: describe the tap")

    # Act
    error = assert_raises(HomebrewTap::Error) { checkout(tap).verify }

    # Assert
    assert_equal out_of_step(tap), error.message
  end

  def test_rejects_a_checkout_with_local_changes
    # Arrange
    tap = @git.clone("tap")
    File.write(File.join(@workspace, "README.md"), Faker::Lorem.paragraph)

    # Act
    error = assert_raises(HomebrewTap::Error) { checkout(tap).verify }

    # Assert
    assert_equal out_of_step(tap), error.message
  end

  def test_rejects_a_tap_that_is_not_installed
    # Arrange
    tap = File.join(@git.root, "absent")

    # Act
    error = assert_raises(HomebrewTap::Error) { checkout(tap).verify }

    # Assert
    assert_equal "the tap is not installed at #{tap}. run 'brew tap gufranco/tap' first.", error.message
  end

  def test_sync_fast_forwards_the_tap_clone_to_this_checkout
    # Arrange
    tap = @git.clone("tap")
    @git.commit(@workspace, "README.md", Faker::Lorem.paragraph, "docs: describe the tap")

    # Act
    checkout(tap).sync

    # Assert
    assert_equal head(@workspace), head(tap)
  end

  def test_sync_leaves_a_tap_that_links_to_this_checkout_alone
    # Arrange
    tap = File.join(@git.root, "linked-tap")
    File.symlink(@workspace, tap)

    # Act
    result = checkout(tap).sync

    # Assert
    assert_nil result
  end

  def test_sync_refuses_a_tap_clone_with_local_changes
    # Arrange
    tap = @git.clone("tap")
    File.write(File.join(tap, "README.md"), Faker::Lorem.paragraph)

    # Act
    error = assert_raises(HomebrewTap::Error) { checkout(tap).sync }

    # Assert
    assert_equal "the tap at #{tap} has local changes. commit or stash them, then sync again.", error.message
  end

  def test_sync_refuses_a_tap_clone_that_has_moved_elsewhere
    # Arrange
    tap = @git.clone("tap")
    @git.commit_locally(tap, "NOTES.md", Faker::Lorem.paragraph, "docs: note on the tap")
    @git.commit(@workspace, "README.md", Faker::Lorem.paragraph, "docs: describe the tap")

    # Act
    error = assert_raises(HomebrewTap::Error) { checkout(tap).sync }

    # Assert
    expected = "the tap at #{tap} has commits this checkout lacks. reset it to origin/main, then sync again."
    assert_equal expected, error.message
  end

  def test_sync_rejects_a_tap_that_is_not_installed
    # Arrange
    tap = File.join(@git.root, "absent")

    # Act
    error = assert_raises(HomebrewTap::Error) { checkout(tap).sync }

    # Assert
    assert_equal "the tap is not installed at #{tap}. run 'brew tap gufranco/tap' first.", error.message
  end

  private

  def head(dir)
    HomebrewTap::Git.new(dir:).run("rev-parse", "HEAD")
  end

  def checkout(tap)
    HomebrewTap::TapCheckout.new(workspace: @workspace, tap:)
  end

  def out_of_step(tap)
    "brew audits the tap at #{tap}, which is not this checkout at the same clean commit. " \
      "bring both to one commit with no local changes, then audit again."
  end
end
