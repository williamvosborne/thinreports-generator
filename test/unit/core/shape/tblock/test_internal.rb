# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Tblock::TestInternal < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  Tblock = ThinReports::Core::Shape::Tblock
  
  def test_read_value_return_the_format_value
    format = flexmock('format')
    format.should_receive(:value => 'format value').times(2)
    format.should_receive(:has_reference? => false)
    
    internal = init_internal(format)
    
    assert_equal internal.read_value, 'format value'
    assert_equal internal.value, 'format value'
  end
  
  def test_read_value_return_the_value_of_referenced_shape
    format = flexmock('format')
    format.should_receive(:has_reference? => true)
    format.should_receive(:ref_id => 'dummy')
    
    internal = init_internal(format)
    
    assert_equal internal.read_value, 'referenced value'
    assert_equal internal.value, 'referenced value'
  end
  
  def test_read_value_return_the_value_stored_in_states
    format = flexmock('format')
    format.should_receive(:has_reference? => false)
    
    internal = init_internal(format)
    internal.states[:value] = 'any value'
    
    assert_equal internal.read_value, 'any value'
    assert_equal internal.value, 'any value'
  end
  
  def test_write_value
    format = flexmock('format')
    format.should_receive(:has_reference? => false)
    
    internal = init_internal(format)
    internal.write_value('value written')
    
    assert_equal internal.value, 'value written'
  end
  
  def test_write_value_show_warnings_when_has_reference
    format = flexmock('format')
    format.should_receive(:has_reference? => true,
                          :ref_id => 'ref id',
                          :id => 'id')
    out, err = capture_io do
      init_internal(format).write_value('value written')
    end
    assert_equal err.chomp, 'The set value is not reflected, ' +
                            "Because 'id' refers to 'ref id'."
  end
  
  def test_real_value_return_the_formatted_value_when_has_any_format
    internal = init_internal(flexmock('format'))
    flexmock(internal, :format_enabled? => true, 
                       :read_value      => 'dummy')
    
    assert_equal internal.real_value, 'formatted value'
  end
  
  def test_real_value_return_the_raw_value_when_has_no_format
    internal = init_internal(flexmock('format'))
    flexmock(internal, :format_enabled? => false,
                       :read_value      => 'raw value')
    
    assert_equal internal.real_value, 'raw value'
  end
  
  def test_format_enabled
    internal = init_internal(flexmock('format'))
    internal.format_enabled(true)
    
    assert_equal internal.states[:format_enabled], true
  end
  
  def test_format_enabled_return_the_true_when_format_has_format
    internal = init_internal(flexmock(:has_format? => true,
                                      :multiple?   => false,
                                      :format_base => nil))
    
    assert_equal internal.format_enabled?, true
  end
  
  def test_format_enabled_return_the_true_when_format_base_has_any_value
    internal = init_internal(flexmock(:has_format? => false,
                                      :multiple?   => false,
                                      :format_base => '{value}'))
    
    assert_equal internal.format_enabled?, true
  end
  
  def test_format_enabled_return_the_false_when_has_not_format_and_base_has_no_value
    internal = init_internal(flexmock(:has_format? => false,
                                      :multiple?   => false,
                                      :format_base => ''))
    
    assert_equal internal.format_enabled?, false
  end
  
  def test_format_enabled_return_the_false_constantly_when_tblock_is_multiple_mode
    internal = init_internal(flexmock(:has_format? => true,
                                      :multiple?   => true,
                                      :format_base => '{value}'))
    
    assert_equal internal.format_enabled?, false
  end
  
  def test_format_enabled_return_the_specified_value
    internal = init_internal(flexmock(:has_format? => true,
                                      :multiple?   => false,
                                      :format_base => '{value}'))
    
    internal.format_enabled(false)
    assert_equal internal.format_enabled?, false
  end
  
  def test_type_of?
    assert_equal init_internal(flexmock('format')).type_of?(:tblock), true
  end
  
  def init_internal(format)
    parent = flexmock('parent')
    parent.should_receive(:item).
        and_return(flexmock(:value => 'referenced value'))
    
    formatter = flexmock('formatter')
    formatter.should_receive(:apply).
        and_return('formatted value')
    
    flexmock(Tblock::Internal).new_instances.should_receive(:formatter).
        and_return(formatter)
    
    Tblock::Internal.new(parent, format)
  end
end