namespace :remote do
  namespace :assets do
  
    desc 'remoting support for rails-slow-assets-workaround'
    task :compile do
      require 'rails-slow-assets-workaround'
      require 'remoting/task'

      remote('rake assets:compile', config.login) do
          source "/usr/local/rvm/scripts/rvm"
          rvm :use, config.ruby
          cd  config.dest
          command("RAILS_ENV=production bundle exec rake assets:compile")          
      end      
    end
    
  end
end

namespace :assets do
  task :compile => :environment do
    require 'sprockets'
  
    # workaround used also by native assets:precompile:all to load sprockets hooks 
    _ = ActionView::Base
    
    if !File.exist?(Rails.root.join('config', 'assets.yml'))
      puts "Nothing to do: #{Rails.root.join('config', 'assets.yml')} does not exists"
      exit
    end
    
    # ==============================================
    # = Read configuration from Rails / assets.yml =
    # ==============================================
    
    env           = Rails.application.assets
    target        = File.join(::Rails.public_path, Rails.application.config.assets.prefix)
    assets        = YAML.load_file(Rails.root.join('config', 'assets.yml'))
    manifest_path = Rails.root.join(target, 'manifest.yml')
    digest        = !!Rails.application.config.assets.digest
    manifest      = digest
    
    
    # =======================
    # = Old manifest backup =
    # =======================
    
    manifest_old = File.exists?(manifest_path) ? YAML.load_file(manifest_path) : {}

    # ==================
    # = Compile assets =
    # ==================

    compiler = Sprockets::StaticCompiler.new(env,
                                            target,
                                            assets,
                                            :digest => digest,
                                            :manifest => manifest)
    compiler.compile
    
    # ===================================
    # = Merge new manifest into old one =
    # ===================================

    manifest_new  = File.exists?(manifest_path) ? YAML.load_file(manifest_path) : {}

    File.open(manifest_path, 'w') do |out|
       YAML.dump(manifest_old.merge(manifest_new), out)
    end
    
    
    # ===============================
    # = Compress assets if required =
    # ===============================
    
  end
end