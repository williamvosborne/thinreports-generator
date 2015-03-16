# coding: utf-8

require 'digest/sha1'

module Thinreports
  module Layout
    
    # @private
    class Format < Core::Shape::Manager::Format
      config_reader last_version: %w( version )
      config_reader report_title: %w( config title )
      config_reader page_paper_type: %w( config page paper-type ),
                    page_width: %w( config page width ),
                    page_height: %w( config page height ),
                    page_orientation: %w( config page orientation )
      
      config_checker 'user', user_paper_type: %w( config page paper-type )
      
      class << self
        
      private
        
        # @param [String] filename
        # @param [Hash] options
        # @option options [Boolean] :force (false)
        def build_internal(filename, options = {})
          build_once(filename, options[:force]) do |content, id|
            raw_format = parse_json(content)
            
            # Check the compatibility of specified layout file.
            unless Thinreports::Layout::Version.compatible?(raw_format['version'])
              info = [filename, raw_format['version'],
                      Thinreports::Layout::Version.inspect_required_rules]
              raise Thinreports::Errors::IncompatibleLayoutFormat.new(*info)
            end
            
            compact_format!(raw_format)
            
            # Build and initialize format.
            new(raw_format, id) do |f|
              build_layout(f) do |type, shape_format|
                Core::Shape::Format(type).build(shape_format)
              end
              clean(f.layout)
            end
          end
        end
        
        # @param [Hash] raw_format A parsed json.
        def compact_format!(raw_format)
          %w( finger-print state version ).each {|attr| raw_format.delete(attr) }
        end
        
        # @param [String] filename
        # @param [Boolean] force (false)
        def build_once(filename, force = false, &block)
          content = read_format_file(filename)
          
          if force
            block.call(content, nil)
          else
            id = Digest::SHA1.hexdigest(content).to_sym
            built_format_registry[id] ||= block.call(content, id)
          end
        end
        
        # @param [String] filename
        # @return [String]
        def read_format_file(filename)
          File.open(filename, 'r:UTF-8') {|f| f.read }
        end
        
        # @return [Hash]
        def built_format_registry
          @built_format_registry ||= {}
        end        
      end
    end
    
  end
end
