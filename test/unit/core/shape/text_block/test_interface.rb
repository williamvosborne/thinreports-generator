# coding: utf-8

require 'test_helper'

class Thinreports::Core::Shape::TextBlock::TestInterface < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  TextBlock = Thinreports::Core::Shape::TextBlock

  def create_interface(format_config = {})
    report = new_report 'layout_text1'
    parent = report.start_new_page

    TextBlock::Interface.new parent, TextBlock::Format.new(format_config)
  end

  def test_format_enabled_asker_should_operate_as_delegator_of_internal
    tblock = create_interface('format' => {'type' => 'datetime'})
    assert_equal tblock.format_enabled?, tblock.internal.format_enabled?
  end

  def test_format_enabled_should_properly_set_value_to_internal
    tblock = create_interface('format' => {'type' => 'number'})
    tblock.format_enabled(false)

    assert_equal tblock.internal.format_enabled?, false
  end

  def test_set_should_properly_set_a_value
    tblock = create_interface
    tblock.set(1000, visible: false)

    assert_equal tblock.value, 1000
  end

  def test_set_should_properly_set_styles
    tblock = create_interface
    tblock.set(1000, color: '#ff0000',
                     bold: true,
                     italic: true)

    assert_equal [tblock.style(:color),
                  tblock.style(:bold),
                  tblock.style(:italic)],
                 ['#ff0000', true, true]
  end
end
