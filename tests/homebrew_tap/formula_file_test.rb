# frozen_string_literal: true

require "test_helper"
require "support/tap_fixture"
require "homebrew_tap/formula_file"
require "homebrew_tap/release"

class FormulaFileTest < Minitest::Test
  def setup
    @tap = TapFixture.new
  end

  def teardown
    @tap.remove
  end

  def test_fails_when_the_formula_does_not_exist
    # Arrange
    path = @tap.formula_path

    # Act
    error = assert_raises(HomebrewTap::Error) { HomebrewTap::FormulaFile.read(path) }

    # Assert
    assert_equal "no formula at #{path}", error.message
  end

  def test_knows_the_formula_is_built_from_its_homepage
    # Arrange
    @tap.write_formula(tag: "v1.0.0")
    formula = HomebrewTap::FormulaFile.read(@tap.formula_path)

    # Act
    built = formula.built_from?("https://github.com/gufranco/#{@tap.name}")

    # Assert
    assert_equal true, built
  end

  def test_knows_the_formula_is_not_built_from_another_homepage
    # Arrange
    @tap.write_formula(tag: "v1.0.0", homepage: "https://example.org/#{@tap.name}")
    formula = HomebrewTap::FormulaFile.read(@tap.formula_path)

    # Act
    built = formula.built_from?("https://github.com/gufranco/#{@tap.name}")

    # Assert
    assert_equal false, built
  end

  def test_reports_the_current_tag_when_it_is_newer_than_the_release
    # Arrange
    @tap.write_formula(tag: "v2.1.0")
    formula = HomebrewTap::FormulaFile.read(@tap.formula_path)

    # Act
    newer = formula.tag_newer_than(release("v2.0.0"))

    # Assert
    assert_equal "v2.1.0", newer
  end

  def test_reports_nothing_when_the_release_is_newer
    # Arrange
    @tap.write_formula(tag: "v2.9.0")
    formula = HomebrewTap::FormulaFile.read(@tap.formula_path)

    # Act
    newer = formula.tag_newer_than(release("v2.10.0"))

    # Assert
    assert_nil newer
  end

  def test_reports_nothing_when_the_release_is_the_current_tag
    # Arrange
    @tap.write_formula(tag: "v2.1.0")
    formula = HomebrewTap::FormulaFile.read(@tap.formula_path)

    # Act
    newer = formula.tag_newer_than(release("v2.1.0"))

    # Assert
    assert_nil newer
  end

  def test_reports_nothing_when_the_formula_url_is_not_a_tagged_archive
    # Arrange
    @tap.write_formula(tag: "v2.1.0", url: "https://github.com/gufranco/#{@tap.name}/archive/main.tar.gz")
    formula = HomebrewTap::FormulaFile.read(@tap.formula_path)

    # Act
    newer = formula.tag_newer_than(release("v1.0.0"))

    # Assert
    assert_nil newer
  end

  def test_saves_the_new_url_and_checksum_and_nothing_else
    # Arrange
    @tap.write_formula(tag: "v1.0.0")
    before = @tap.formula_text
    checksum = Faker::Crypto.sha256
    url = @tap.tagged_url("v1.1.0")

    # Act
    HomebrewTap::FormulaFile.read(@tap.formula_path).pointed_at(url:, sha256: checksum).save

    # Assert
    expected = before.sub(@tap.tagged_url("v1.0.0"), url).sub(TapFixture::UNSET_SHA256, checksum)
    assert_equal expected, @tap.formula_text
  end

  private

  def release(tag)
    HomebrewTap::Release.new(name: @tap.name, tag:)
  end
end
