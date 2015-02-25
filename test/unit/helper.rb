# coding: utf-8

require 'rubygems'
require 'minitest/spec'
require 'minitest/unit'
require 'test/unit'
require 'flexmock/test_unit'
require 'turn/autorun'

Turn.config.format = :dot

require 'thinreports'
require 'fileutils'
require 'digest/sha1'

MiniTest::Unit.autorun

module ThinReports::TestHelpers
  include FlexMock::TestCase

  ROOT_DIR = File.expand_path(File.dirname(__FILE__))
  TEMP_DIR = ROOT_DIR + '/tmp'

  def self.included(klass)
    klass.class_eval do
      alias_method :_teardown, :teardown
      def teardown
        _teardown
        clear_outputs
      end
    end
  end

  def clear_outputs
    FileUtils.rm Dir.glob(TEMP_DIR + '/*')
  end

  def clean_whitespaces(str)
    str.gsub(/^\s*|\n\s*/, '')
  end

  def skip_if_ruby19
    if RUBY_VERSION > '1.9'
      skip('This test is not required more than Ruby 1.9.')
    end
  end

  def skip_if_ruby18
    if RUBY_VERSION < '1.9'
      skip('This test is not required Ruby 1.8 below.')
    end
  end

  def create_basic_report(file, &block)
    report = ThinReports::Report.new :layout => data_file(file)
    block.call(report) if block_given?
    report
  end

  def create_basic_layout(file)
    ThinReports::Layout.new(data_file(file))
  end

  def create_basic_layout_format(file)
    ThinReports::Layout::Format.build(data_file(file))
  end

  def data_file(filename)
    File.join(File.dirname(__FILE__), 'data', filename)
  end

  def temp_file(extname = 'pdf')
    File.join(TEMP_DIR, (('a'..'z').to_a + (0..9).to_a).shuffle[0, 8].join + ".#{extname}")
  end
end
