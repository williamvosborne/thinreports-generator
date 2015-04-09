# coding: utf-8

require 'test_helper'

class Thinreports::Core::Shape::Style::TestGraphic < Minitest::Test
  include Thinreports::TestHelper

  def create_graphic_style
    format = Thinreports::Core::Shape::Basic::Format.new({})
    Thinreports::Core::Shape::Style::Graphic.new(format)
  end

  def test_border_color_should_properly_set_to_internal_styles_as_stroke_style
    style = create_graphic_style
    style.border_color = '#ff0000'

    assert_equal style.styles['stroke'], '#ff0000'
  end

  def test_border_width_should_properly_set_to_internal_styles_as_stroke_width_style
    style = create_graphic_style
    style.border_width = 1

    assert_equal style.styles['stroke-width'], 1
  end

  def test_border_width_should_set_stroke_opacity_to_1_when_width_is_not_zero
    style = create_graphic_style
    style.border_width = 5

    assert_equal style.styles['stroke-opacity'], '1'
  end

  def test_fill_color_should_properly_set_to_internal_styles_as_fill_style
    style = create_graphic_style
    style.fill_color = '#0000ff'

    assert_equal style.styles['fill'], '#0000ff'
  end

  def test_border_should_return_an_Array_included_border_width_and_border_color
    style = create_graphic_style
    style.border_width = 1
    style.border_color = '#ff0000'

    assert_equal style.border, [style.border_width, style.border_color]
  end

  def test_border_should_properly_set_both_border_width_and_border_color_from_the_specified_array_argument
    style = create_graphic_style
    style.border = [5, '#000000']

    assert_equal style.border, [5, '#000000']
  end
end
