# frozen_string_literal: true

require "test_helper"

class NazukeTest < Minitest::Test
  FORMULA = File.expand_path("../../Formula/nazuke.rb", __dir__).freeze
  LIBEXEC = Regexp.new('^ {4}libexec\.install (.+)$').freeze

  def test_installs_the_word_packs_beside_the_library_it_reads_them_from
    # Arrange
    text = File.read(FORMULA)

    # Act
    installed = text[LIBEXEC, 1].to_s.scan(/"([^"]+)"/).flatten

    # Assert
    assert_equal %w[bin lib share], installed
  end
end
