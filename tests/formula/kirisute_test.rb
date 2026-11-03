# frozen_string_literal: true

require "test_helper"

class KirisuteTest < Minitest::Test
  FORMULA = File.expand_path("../../Formula/kirisute.rb", __dir__).freeze
  DEPENDENCY = Regexp.new('^ {2,4}depends_on "([^"]+)"$').freeze

  def test_brings_maxcso_from_the_tap_and_gum_and_nothing_else
    # Arrange
    text = File.read(FORMULA)

    # Act
    dependencies = text.scan(DEPENDENCY).flatten

    # Assert
    assert_equal %w[gufranco/tap/maxcso gum], dependencies
  end
end
