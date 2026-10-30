# frozen_string_literal: true

require "test_helper"

class AnypatchTest < Minitest::Test
  FORMULA = File.expand_path("../../Formula/anypatch.rb", __dir__).freeze

  def test_installs_from_the_lockfile_with_uv_and_not_the_virtualenv_helpers
    # Arrange
    text = File.read(FORMULA)

    # Act
    mixins = text.scan(/^  include (\S+)$/).flatten

    # Assert
    assert_equal [], mixins
    assert_includes text, 'system "uv", "sync", "--frozen", "--no-dev", "--no-editable"'
  end
end
