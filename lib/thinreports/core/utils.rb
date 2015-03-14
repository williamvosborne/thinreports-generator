# coding: utf-8

module Thinreports
  module Utils
    def self.included(klass)
      klass.extend self
    end

    def warn(message)
      Kernel.warn message
    end

    def deep_copy(src)
      case src
      when Hash
        src.inject({}) {|h, (k, v)| h[k] = (v.dup rescue v); h }
      when Array
        src.map {|a| a.dup rescue a }
      else
        raise ArgumentError
      end
    end

    def blank_value?(value)
      case value
      when String   then value.empty?
      when NilClass then true
      else false
      end
    end

    def call_block_in(scope, &block)
      return scope unless block_given?

      if block.arity == 1
        block.call(scope)
      else
        scope.instance_eval(&block)
      end
      scope
    end
  end

  extend Utils
end
