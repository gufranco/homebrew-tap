# frozen_string_literal: true

require "test_helper"

class KodouguTest < Minitest::Test
  MEMBERS = %w[fusho jimaku kakikomi katazuke kiban kirisute kiyome shiwake yakitsuke].freeze
  DEPENDENCY = Regexp.new('^ {2,4}depends_on "([^"]+)"$').freeze

  def test_every_kodougu_formula_brings_gum_for_its_terminal_interface
    # Arrange
    formulae = MEMBERS.to_h { |name| [name, File.read(File.expand_path("../../Formula/#{name}.rb", __dir__))] }

    # Act
    without_gum = formulae.reject { |_name, text| text.scan(DEPENDENCY).flatten.include?("gum") }.keys

    # Assert
    assert_empty without_gum
  end
end
