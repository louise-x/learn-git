# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "my-test"
set :repo_url, "git@github.com:louise-x/learn-git.git"


# at server machine
set :passenger_restart_with_touch, true
set :rails_env, :development
set :puma_threads, [4, 16]
# Don’t change these unless you know what you’re doing
set :pty, true
set :use_sudo, false
set :stage, :production
set :deploy_via, :remote_cache
set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log, "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, false
set :deploy_to, "/var/www/my-test"

append :linked_dirs, 'log', 'tmp/cache'

namespace :puma do
 desc "Create Directories for Puma Pids and Socket"
 task :make_dirs do
 on roles(:app) do
 execute "mkdir #{shared_path}/tmp/sockets -p"
 execute "mkdir #{shared_path}/tmp/pids -p"
 end
 end
 
 before :start, :make_dirs
end

namespace :deploy do
 desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/main`
      puts "WARNING: HEAD is not the same as origin/main"
      puts "Run `git push` to sync changes."
      exit
    end
  end
 end
 
 desc "Initial Deploy"
 task :initial do
 on roles(:app) do
 before "deploy:restart", "puma:start"
 invoke "deploy"
 end
 end
 
#  desc "cleanup application"
#  task :clean_cache do
#    on roles(:app) do
#    invoke "bootsnap:clean_cache"
#  end
# end
 
 desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
    invoke "puma:restart"
  end
 end
 
 before :starting, :check_revision
 after :finishing, :compile_assets
 after :finishing, :cleanup
 after :finishing, :restart
 after :cleanup, "bootsnap:clean_cache"
end

set :noaccess_interval, -1

namespace :bootsnap do
  desc "clean bootsnap cach"
  task :clean_cache do
    on roles(:app) do
      sudo(:haha, "sth go waong") rescue true
    # puts "this is a test............................"
    # bootsnap_compile_cache_dir = "#{fetch(:deploy_to)}/shared/tmp/cache/bootsnap"
    # tmp_purge_folder = "/tmp/test"
    # puts "creating tmp purge dir...."
    # execute(:mkdir, "-p #{tmp_purge_folder}")
    # # execute whruby_dir_with_lazy, "/var/www/my-test/shared/tmp/cache/bootsnap/compile-cache/00"
    # # execute :bash, "-c /home/ec2-user/.rvm/rubies/ruby-2.6.6/bin/ruby /var/www/my-test/current/cleanup.rb"
    # # execute :find, "/var/www/my-test/shared/tmp/cache/bootsnap/compile-cache/00 -atime -1 -type f"
    # # puts capture("find '/var/www/my-test/shared/tmp/cache/bootsnap/' -maxdepth 5 -atime +1 -type f  | xargs -I '{}' -0 cp '{}' /tmp/test ")
    # execute(:find, 
    #      "#{bootsnap_compile_cache_dir} -maxdepth 3 -atime #{fetch(:noaccess_interval)} -type f -print0 "\
    #      " | xargs -I '{}' -0 cp '{}' #{tmp_purge_folder} "
    #      )
    # file_counts = capture("ls  #{tmp_purge_folder} | wc -l")
    # puts "it is going to purge #{file_counts} files"
    # execute(:rm, "-r  #{tmp_purge_folder}") rescue true
    # execute :find, "/var/www/my-test/shared/tmp/cache/bootsnap -maxdepth 4 -atime -1 -type f -exec cp \{\} '/tmp/test/' "
  end
end
 
  def ruby_dir_with_lazy folder
    now = Time.now
    files = []
    puts "--- address the folder : #{folder}"
    Dir.glob("#{folder}/**/*").lazy.each do |file|
      puts "--- checking #{file}"
      if File.file? file
        atime = File.atime(file)
        delta = now - atime
        puts "delta is ....#{delta}"
        if delta > 600
          files << file
        end
      end
    end
    puts "found access no more 10min ago: #{files}"
  end

end
# Default branch is :main
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
