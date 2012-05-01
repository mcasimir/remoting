require 'remote/dsl/string'
require 'remote/dsl/symbol'

module Remote
  module Dsl
    
    class ScriptBuilder
      attr_reader :commands
      
      class << self
        def build(&block)
          instance = self.new
          instance.instance_eval(&block)
          instance.commands
        end
      end
    
      def initialize
        @commands = []
      end
    
      private

      def method_missing(*args)
        @command << command(*args)
      end

      def command(*args)
        args.map(&:to_s).join(" ")
      end
    
    end
    
  end
end