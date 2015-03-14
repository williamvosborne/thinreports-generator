# coding: utf-8

module Thinreports
  module Core::Shape
    
    # @private
    class Basic::Internal < Base::Internal
      # Delegate to Format's methods
      format_delegators :id, :svg_tag, :type
      
      def style
        @style ||= Style::Graphic.new(format)
      end
      
      def type_of?(type_name)
        ['s-basic', self.type].include?("s-#{type_name}")
      end

      def identifier
        "#{id}#{style.identifier}"
      end
    end
  end
end
