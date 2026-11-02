# frozen_string_literal: true

require "test_helper"

class KirisuteTest < Minitest::Test
  FORMULA = File.expand_path("../../Formula/kirisute.rb", __dir__).freeze
  DEPENDENCY = Regexp.new('^ {2,4}depends_on "([^"]+)"$').freeze

  def test_needs_nothing_beyond_the_tools_every_system_ships
    # Arrange
    text = File.read(FORMULA)

    # Act
    dependencies = text.scan(DEPENDENCY).flatten

    # Assert
    assert_equal [], dependencies
  end
end
