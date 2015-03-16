# coding: utf-8

require 'test_helper'

class Thinreports::Core::TestShape < Minitest::Test
  include Thinreports::TestHelper
  
  # Alias
  ShapeModule = Thinreports::Core::Shape
  
  def test_find_by_type_should_return_PageNumber
    assert_same ShapeModule.find_by_type('s-pageno'), ShapeModule::PageNumber
  end

  def test_find_by_type_should_return_ImageBlock
    assert_same ShapeModule.find_by_type('s-iblock'), ShapeModule::ImageBlock
  end
  
  def test_find_by_type_should_return_TextBlock
    assert_same ShapeModule.find_by_type('s-tblock'), ShapeModule::TextBlock
  end
  
  def test_find_by_type_should_return_List
    assert_same ShapeModule.find_by_type('s-list'), ShapeModule::List
  end
  
  def test_find_by_type_should_return_Text
    assert_same ShapeModule.find_by_type('s-text'), ShapeModule::Text
  end
  
  def test_find_by_type_should_return_Basic_as_Image
    assert_same ShapeModule.find_by_type('s-image'), ShapeModule::Basic
  end
  
  def test_find_by_type_should_return_Basic_as_Line
    assert_same ShapeModule.find_by_type('s-line'), ShapeModule::Basic
  end
  
  def test_find_by_type_should_return_Basic_as_Rect
    assert_same ShapeModule.find_by_type('s-rect'), ShapeModule::Basic
  end
  
  def test_find_by_type_should_return_Basic_as_Ellipse
    assert_same ShapeModule.find_by_type('s-ellipse'), ShapeModule::Basic
  end
  
  def test_find_by_type_should_raise
    assert_raises Thinreports::Errors::UnknownShapeType do
      ShapeModule.find_by_type('unknown')
    end
  end
  
  def test_Configuration_should_return_Configuration_of_List
    assert_same ShapeModule::Configuration('s-list'),
                ShapeModule::List::Configuration
  end
  
  def test_Configuration_should_raise
    # When shape don't have a Configuration
    assert_raises Thinreports::Errors::NoConfigurationFound do
      ShapeModule::Configuration('s-line')
    end
  end
end
