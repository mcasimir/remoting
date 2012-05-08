require 'remoting/dsl/string'

module Remoting
  module Dsl
    
    class ScriptBuilder
      shadow_methods = %w(gem cd chdir chmod chmod_R chown chown_R cmp compare_file compare_stream copy copy_entry copy_file copy_stream cp cp_r getwd identical? install link ln ln_s ln_sf makedirs mkdir mkdir_p mkpath move mv pwd remove remove_dir remove_entry remove_entry_secure remove_file rm rm_f rm_r rm_rf rmdir rmtree safe_unlink symlink touch uptodate?)

      shadow_methods.each do |name|
        define_method name do |*args|
          self.command(name, *args)
        end
      end

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

      def commands()
          @commands.flatten.map! do |c|
            c.split(/[\r\n]/).map{|l|
              line = l.strip
              line.empty? ? nil : line
            }
          end.flatten.compact.delete_if(&:empty?)
      end

      def command(*args)
        cmd = args.map(&:to_s).join(" ")
        @commands << cmd
        cmd
      end
    
      private

      def method_missing(*args)
        command(*args)       
      end


    end
    
  end
end