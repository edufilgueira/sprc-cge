# config valid only for current version of Capistrano
lock "3.16.0"

set :application, "sprc"
#set :repo_url, "git@github.com:caiena/sprc.git"
set :repo_url, "git@git.cge.local:g_sprc/sprc.git"

set :rails_env, 'production'

set :passenger_rvm_ruby_version, -> { fetch(:stage_passenger_rvm_ruby_version, '2.2.3@global') }

# RVM
set :rvm_type, :system
set :rvm_ruby_version, -> { fetch(:stage_rvm_ruby_version, '2.5.8@sprc') }
set :rvm_roles, [:app, :web]

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
if ENV['BRANCH']
  set :branch, ENV['BRANCH']
else
  ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
end

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, -> { fetch(:stage_deploy_to, "/app/#{fetch(:application)}/#{fetch(:stage)}") }

set :sidekiq_path, -> { fetch(:stage_sidekiq_path, 'service sidekiq') }
set :sidekiq_exports_path, -> { fetch(:stage_sidekiq_exports_path, 'service sidekiq.exports') }
set :sidekiq_role, :sidekiq
set :sidekiq_export_role, :sidekiq_export

# Whenever
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/application.yml",
                      "config/database.yml",
                      "config/secrets.yml",
                      "config/skylight.yml",
                      "config/newrelic.yml",
                      "config/sidekiq.yml",
                      "config/sidekiq.exports.yml"

# Default value for linked_dirs is []
append :linked_dirs,  "log",
                      "tmp/pids",
                      "tmp/cache",
                      "tmp/sockets",
                      "public/system",
                      "uploads",
                      "public/files"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
