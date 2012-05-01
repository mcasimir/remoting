require "yaml"

#
# Tasks
#
namespace :remote do

  task :deploy => [:push] do
    remote("cd #{config[:dest]}", "git pull")
  end

  task :reset do
    remote("cd #{config[:dest]}","git reset --hard HEAD", "git clean -f -d")
  end

  task :restart => [] do
      remote("mkdir -p #{config[:dest]}/tmp","touch #{config[:dest]}/tmp/restart.txt")
  end

  task :bundle => [] do

    if config[:gemset]
        gemset_exist = remote( load_rvm,
                use_ruby(config[:ruby]),
                "rvm gemset list | egrep ^[\\ ]+#{config[:gemset]}[\\ ]*$  | wc -l"
        ).to_i > 0

        if !gemset_exist
          remote(load_rvm, use_ruby(config[:ruby]),
            "rvm gemset create #{config[:gemset]}",
            "rvm gemset use #{config[:gemset]}",
            "gem install bundler --no-ri --no-rdoc",
            "cd #{config[:dest]}",
            "RAILS_ENV=production bundle install --without development test --deployment"
          )
        else
          remote(load_rvm, use_ruby(config[:ruby]),
            "rvm gemset use #{config[:gemset]}",
            "cd #{config[:dest]}",
            "RAILS_ENV=production bundle install --without development test --deployment"
          )
        end
    else
          remote(load_rvm, use_ruby(config[:ruby]),
            "cd #{config[:dest]}",
            "RAILS_ENV=production bundle install --without development test --deployment"
          )
    end

  end

  task :push, [:message] => [] do |t, args|
    message = args[:message] || "commit"
    local("git add .",
          "git commit -a -m '#{message}'",
          "git push origin master")
  end

  task :create_db_and_grant, [:username, :password] => [] do |t, args|
    db  = YAML.load_file(Rails.root.join("config", "database.yml"))
    sql = "CREATE DATABASE #{db["production"]["database"]}; GRANT ALL PRIVILEGES ON #{db["production"]["database"]}.* TO '#{db["production"]["username"]}'@'localhost' IDENTIFIED BY '#{db["production"]["password"]}' WITH GRANT OPTION;"
    puts remote("mysql -u #{args[:username]} -p#{args[:password]} -e #{sql.inspect}")
  end


  task :rake, [:taskname] => [] do |t, args|

    if config[:gemset]
        gemset_exist = remote( load_rvm,
                use_ruby(config[:ruby]),
                "rvm gemset list | egrep ^[\\ ]+#{config[:gemset]}[\\ ]*$  | wc -l"
        ).to_i > 0

        if !gemset_exist
          remote(load_rvm, use_ruby(config[:ruby]),
            "rvm gemset create #{config[:gemset]}",
            "rvm gemset use #{config[:gemset]}",
            "gem install bundler --no-ri --no-rdoc",
            "cd #{config[:dest]}",
            "RAILS_ENV=production bundle exec #{args[:taskname]}"
          )
        else
          remote(load_rvm, use_ruby(config[:ruby]),
            "rvm gemset use #{config[:gemset]}",
            "cd #{config[:dest]}",
            "RAILS_ENV=production bundle exec rake #{args[:taskname]}"
          )
        end
    else
          remote(load_rvm, use_ruby(config[:ruby]),
            "cd #{config[:dest]}",
            "RAILS_ENV=production bundle exec rake #{args[:taskname]}"
          )
    end
  end

  task :setup  => [] do
    local(
      "git init",
      "git remote add origin #{config[:repo]}"
    )

    puts
    puts
    branch = "-b #{config[:branch]}" if config[:branch]
    remote("git clone #{branch} #{config[:origin]} #{config[:dest]}")

  end

  task :log, [:lines, :filename] => [:environment] do |t, args|
          filename = args[:filename] || "production"
          filename = "#{filename}.log" unless filename =~ /\.[a-z]+$/
          lines    = args[:lines] || "100"

          remote("cd #{config[:dest]}",
                "tail -#{lines} log/#{filename}")
  end

  task :logs => [:log] do
  end

end



