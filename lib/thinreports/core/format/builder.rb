# coding: utf-8

require 'json'

module Thinreports::Core
  module Format

    module Builder
      def build(*args)
        build_internal(*args)
      rescue Thinreports::Errors::Basic
        raise
      rescue
        raise Thinreports::Errors::InvalidLayoutFormat
      end

      # @abstract
      def build_internal
        raise NotImplementedError
      end

      # @param [Thinreports::Core::Format::Base] format
      # @param [Hash] options
      def build_layout(format, options = {}, &block)
        level = '-' * ((options[:level] || 1 ) - 1)
        pattern = /<!--#{level}SHAPE(.*?)SHAPE#{level}-->/

        format.layout.scan(pattern) do |m|
          shape_format = block.call(*parsed_format_and_shape_type(m.first))
          format.shapes[shape_format.id.to_sym] = shape_format
        end
        format.layout.gsub!(pattern, '')
      end

      # @param [String] svg
      def clean(svg)
        svg.gsub!(/<!--.*?-->/, '')
      end

      # @param [String] svg
      def clean_with_attributes(svg)
        clean(svg)
        svg.gsub!(/ x\-[a-z\d\-]+?=".*?"/, '')
        svg.gsub!(/ class=".*?"/, '')
      end

      def shape_tag(format)
        %{<%= r(:"#{format.id}")%>}
      end

      def parsed_format_and_shape_type(json_string)
        f = parse_json(json_string)
        [ f['type'], f ]
      end

      def parse_json(json_string)
        JSON.parse(json_string)
      end
    end

  end
end
