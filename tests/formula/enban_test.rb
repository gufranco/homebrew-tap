# frozen_string_literal: true

require "test_helper"

class EnbanTest < Minitest::Test
  FORMULA = File.expand_path("../../Formula/enban.rb", __dir__).freeze
  LIBEXEC = Regexp.new('^ {4}libexec\.install (.+)$').freeze

  def test_installs_the_launcher_beside_the_library_it_sources_from_its_parent_folder
    # Arrange
    text = File.read(FORMULA)

    # Act
    installed = text[LIBEXEC, 1].to_s.scan(/"([^"]+)"/).flatten

    # Assert
    assert_equal %w[bin lib], installed
  end
end
