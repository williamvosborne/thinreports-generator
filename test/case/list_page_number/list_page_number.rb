# coding: utf-8

testcase :list_page_number, 'Draw page-number automatically each list' do |t|
  report = ThinReports::Report.new :layout => t.layout_filename

  report.start_new_page
  report.page.item(:group_no).value('Group A')

  10.times { report.list.add_row }

  report.start_new_page
  report.page.item(:group_no).value('Group B')

  20.times { report.list.add_row }

  report.generate :filename => t.output_filename
end
