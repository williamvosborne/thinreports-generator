# coding: utf-8

require 'test_helper'

class ThinReports::Generator::PDF::TestDrawShape < Minitest::Test
  include ThinReports::TestHelper

  def setup
    @pdf = ThinReports::Generator::PDF::Document.new
  end

  def create_tblock_interface(format_config = {})
    report = new_report 'layout_text1'
    parent = report.start_new_page

    format = ThinReports::Core::Shape::TextBlock::Format.new format_config
    ThinReports::Core::Shape::TextBlock::Interface.new parent, format
  end

  def test_shape_text_attrs_should_return_attrs_containing_an_overflow_property
    tblock = create_tblock_interface('id' => 'text', 'overflow' => 'truncate')
    assert_equal @pdf.send(:shape_text_attrs, tblock.internal)[:overflow], :truncate
  end

  def test_shape_text_attrs_should_return_attrs_containing_an_valign_property
    tblock = create_tblock_interface('id' => 'text', 'valign' => 'top')
    assert_equal @pdf.send(:shape_text_attrs, tblock.internal)[:valign], :top
  end

  def test_shape_text_attrs_should_return_attrs_containing_an_line_height_unless_line_height_is_blank
    tblock = create_tblock_interface('id' => 'text', 'line-height' => '10')
    assert_equal @pdf.send(:shape_text_attrs, tblock.internal)[:line_height], '10'
  end

  def test_shape_text_attrs_should_return_attrs_uncontaining_an_line_height_if_line_height_is_blank
    tblock = create_tblock_interface('id' => 'text', 'line-height' => '')
    assert_nil @pdf.send(:shape_text_attrs, tblock.internal)[:line_height]
  end

  def test_shape_text_attrs
    tblock = create_tblock_interface('id' => 'text', 'word-wrap' => 'none')
    assert_includes @pdf.send(:shape_text_attrs, tblock.internal).keys, :word_wrap
  end
end
