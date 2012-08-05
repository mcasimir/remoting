module Remoting
  class RecipeGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../../recipes', __FILE__)
    
    argument :names, :as => :array, :required => true, :banner => "RECIPE1 RECIPE2 ..."
        
    def install_recipe
      names.each {|name|
        template "#{name}.rake", Rails.root.join("lib", "tasks", "remote", "#{name}.rake")
      }
    end
    
  end
end
