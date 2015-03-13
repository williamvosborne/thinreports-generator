# coding: utf-8

require 'test_helper'

class ThinReports::Generator::PDF::TestDocument < Minitest::Test
  include ThinReports::TestHelper

  # Alias
  Document = ThinReports::Generator::PDF::Document

  def test_new_without_page_creation
    pdf = Document.new
    assert_equal pdf.internal.page_count, 0
  end

  def test_new_with_zero_margin_canvas
    pdf = Document.new
    assert_equal pdf.internal.page.margins.values, [0, 0, 0, 0]
  end
end
