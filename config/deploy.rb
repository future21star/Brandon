# config valid only for current version of Capistrano
lock '3.6.1'


USER='quotr'
USER_HOME='/home/' + USER
DEPLOY_TO=USER_HOME + '/app'
SECURE_DATA=ENV["PATH_TO_HOSTING"]

unless SECURE_DATA
  raise StandardError.new("Env variable PATH_TO_HOSTING  must be set")
end


set :application, 'Quotr'
set :repo_url, 'git@bitbucket.org:Quotr/quotr.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, 'master'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, DEPLOY_TO
set :user, USER

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'
# append :linked_files, "#{USER_HOME}/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5


# set :default_env, { rvm_bin_path: '~/.rvm/bin' }
set :rvm_ruby_version, '2.3.3'
set :use_sudo, false
set :deploy_via, :copy



# default_run_options[:pty] = true
