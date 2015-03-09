# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::PDF::TestFont < Minitest::Test
  include ThinReports::TestHelpers

  Font = ThinReports::Generator::PDF::Font

  def teardown
    # Reset font settings
    ThinReports.configure do |c|
      c.fallback_fonts = []
      c.generator.pdf.eudc_fonts = []
    end
  end

  def test_setup_fonts
    pdf = document.pdf

    Font::BUILTIN_FONTS.each do |name, font|
      assert_equal font, pdf.font_families[name]
    end

    Font::PRAWN_BUINTIN_FONT_ARIASES.each do |alias_font, original_font|
      assert_equal pdf.font_families[alias_font],
                   pdf.font_families[original_font]
    end

    assert_equal Font::DEFAULT_FALLBACK_FONTS, pdf.fallback_fonts[-2..-1]
  end

  def test_setup_fonts_with_custom_fallback_fonts
    ThinReports.configure do |c|
      c.fallback_fonts = []
      c.generator.pdf.eudc_fonts = []
    end
    assert_equal Font::DEFAULT_FALLBACK_FONTS,
                 document.pdf.fallback_fonts

    ThinReports.configure do |c|
      c.fallback_fonts = 'IPAGothic'
      c.generator.pdf.eudc_fonts = []
    end
    assert_equal ['IPAGothic'] + Font::DEFAULT_FALLBACK_FONTS,
                 document.pdf.fallback_fonts

    ThinReports.configure do |c|
      c.fallback_fonts = ['IPAMincho']
      c.generator.pdf.eudc_fonts = [data_file('font.ttf')]
    end
    assert_equal ['Custom-fallback-font0', 'IPAMincho'] + Font::DEFAULT_FALLBACK_FONTS,
                 document.pdf.fallback_fonts

    ThinReports.configure do |c|
      c.generator.pdf.eudc_fonts = [data_file('font.ttf')]
      c.fallback_fonts = ['IPAMincho', 'IPAMincho', data_file('font.ttf')]
    end
    assert_equal ['Custom-fallback-font0', 'IPAMincho'] + Font::DEFAULT_FALLBACK_FONTS,
                 document.pdf.fallback_fonts
  end

  def test_setup_fonts_with_unknown_custom_fallback_fonts
    ThinReports.configure do |c|
      c.fallback_fonts = ['/path/to/unknown.ttf']
      c.generator.pdf.eudc_fonts = []
    end

    assert_raises ThinReports::Errors::FontFileNotFound do
      create_document
    end
  end

  def test_font_helpers
    doc = document

    assert_equal 'Helvetica', doc.default_family

    assert_equal 'Helvetica', doc.default_family_if_missing('unknown')
    assert_equal 'IPAMincho', doc.default_family_if_missing('IPAMincho')

    assert_equal false, doc.font_has_style?('IPAMincho', :bold)
    assert_equal true, doc.font_has_style?('Courier New', :bold)
  end

  def document
    ThinReports::Generator::PDF::Document.new
  end
  alias_method :create_document, :document
end
