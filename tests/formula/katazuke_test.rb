# frozen_string_literal: true

require "test_helper"

class KatazukeTest < Minitest::Test
  FORMULA = File.expand_path("../../Formula/katazuke.rb", __dir__).freeze
  DEPENDENCY = Regexp.new('^ {2,4}depends_on "([^"]+)"$').freeze

  def test_brings_fatsort_on_every_platform
    # Arrange
    text = File.read(FORMULA)

    # Act
    dependencies = text.scan(DEPENDENCY).flatten

    # Assert
    assert_equal %w[fatsort], dependencies
  end
end
