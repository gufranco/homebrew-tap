# frozen_string_literal: true

require "test_helper"

class ZsnesTest < Minitest::Test
  FORMULA = File.expand_path("../../Formula/zsnes.rb", __dir__).freeze
  UPSTREAM_DEPENDENCIES = ["pkgconf", "libpng", "sdl3"].freeze

  def test_builds_with_the_dependencies_the_upstream_formula_names
    # Arrange
    text = File.read(FORMULA)

    # Act
    missing = UPSTREAM_DEPENDENCIES.reject { |name| text.match?(Regexp.new(%Q(^  depends_on "#{name}"))) }

    # Assert
    assert_equal [], missing
  end

  def test_the_test_block_runs_the_headless_self_test
    # Arrange
    text = File.read(FORMULA)

    # Act
    test_block = text[/^  test do\n(.*?)^  end\n/m, 1]

    # Assert
    assert_includes test_block, %Q(ENV["ZSNES_SELFTEST"] = "1")
    assert_includes test_block, %Q(ENV["SDL_VIDEODRIVER"] = "dummy")
    assert_includes test_block, "SELFTEST: PASS"
  end
end
