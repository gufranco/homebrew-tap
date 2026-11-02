# frozen_string_literal: true

require "test_helper"

class KibanTest < Minitest::Test
  FORMULA = File.expand_path("../../Formula/kiban.rb", __dir__).freeze
  DEPENDENCY = Regexp.new('^ {2,4}depends_on "([^"]+)"$').freeze

  def test_brings_the_docker_client_everywhere_and_the_colima_vm_with_compose_on_macos
    # Arrange
    text = File.read(FORMULA)

    # Act
    macos_block = text[/^  on_macos do\n(.*?)^  end\n/m, 1].to_s

    # Assert
    assert_equal %w[docker colima docker-compose], text.scan(DEPENDENCY).flatten
    assert_equal %w[colima docker-compose], macos_block.scan(DEPENDENCY).flatten
  end
end
