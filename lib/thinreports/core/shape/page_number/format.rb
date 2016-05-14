# coding: utf-8

module Thinreports
  module Core::Shape

    class PageNumber::Format < Basic::Format
      config_reader :target
      config_reader default_format: %w( format )

      # For saving compatible 0.8.x format API
      config_reader overflow: %w( style overflow )

      def id
        @id ||= blank_value?(read('id')) ? self.class.next_default_id : read('id')
      end

      # FIXME: make be DRY
      def box
        @box ||= {
          'x' => attributes['x'],
          'y' => attributes['y'],
          'width' => attributes['width'],
          'height' => attributes['height']
        }
      end

      def self.next_default_id
        @id_counter ||= 0
        "__pageno#{@id_counter += 1}"
      end
    end

  end
end
