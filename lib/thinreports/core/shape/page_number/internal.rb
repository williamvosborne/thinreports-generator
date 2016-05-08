# coding: utf-8

module Thinreports
  module Core::Shape

    class PageNumber::Internal < Basic::Internal
      format_delegators :box

      def read_format
        states.key?(:format) ? states[:format] : format.default_format.dup
      end

      def reset_format
        states.delete(:format)
      end

      def write_format(format)
        states[:format] = format.to_s
      end

      def build_format(page_no, page_count)
        return '' if blank_value?(read_format)

        if start_page_number > 1
          page_no += start_page_number - 1
          page_count += start_page_number - 1
        end

        read_format.dup.tap do |f|
          f.gsub! '{page}', page_no.to_s
          f.gsub! '{total}', page_count.to_s
        end
      end

      def style
        @style ||= PageNumber::Style.new(format)
      end

      def for_report?
        blank_value?(format.target)
      end

      def type_of?(type_name)
        type_name == PageNumber::TYPE_NAME
      end

      def start_page_number
        for_report? ? parent.report.start_page_number : 1
      end
    end

    class PageNumber::Style < Style::Text
      accessible_styles.delete :valign
    end

  end
end
