# coding: utf-8

require 'test_helper'

class ThinReports::TestReport < Minitest::Test
  include ThinReports::TestHelper

  # Alias
  Report = ThinReports::Report

  def test_new_should_delegate_to_Base_new
    flexmock(Report::Base).should_receive(:new).once
    Report.new
  end

  def test_create_should_delegate_to_Base_create
    flexmock(Report::Base).should_receive(:create).once
    Report.create
  end

  def test_generate_should_delegate_to_Base_generate
    flexmock(Report::Base).should_receive(:generate).once
    Report.generate
  end
end
