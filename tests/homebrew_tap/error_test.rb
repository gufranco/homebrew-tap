# frozen_string_literal: true

require "test_helper"
require "homebrew_tap/error"

class ErrorTest < Minitest::Test
  def test_is_a_standard_error_carrying_its_message
    # Arrange
    message = Faker::Lorem.sentence

    # Act
    error = HomebrewTap::Error.new(message)

    # Assert
    assert_kind_of StandardError, error
    assert_equal message, error.message
  end
end
