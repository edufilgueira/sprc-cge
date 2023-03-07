#
# Infra oficial, com repositório CGE.
#
set :deploy_to, -> { fetch(:stage_deploy_to, "/app/#{fetch(:application)}") }

set :repo_url, "git@git.cge.local:g_sprc/sprc.git"

set :default_env, {
  "PASSENGER_INSTANCE_REGISTRY_DIR" => "/var/run/passenger-instreg"
}

set :passenger_rvm_ruby_version, -> { fetch(:stage_passenger_rvm_ruby_version, '2.5.8@sprc') }
set :rvm_ruby_version, -> { fetch(:stage_rvm_ruby_version, '2.5.8@sprc') }

#set :passenger_rvm_ruby_version, -> { fetch(:stage_passenger_rvm_ruby_version, '2.4.9@sprc') }
#set :rvm_ruby_version, -> { fetch(:stage_rvm_ruby_version, '2.4.9@sprc') }

set :stage_sidekiq_path, 'service sprc.sidekiq'
set :stage_sidekiq_exports_path, 'service sprc.sidekiq.exports'

# app-01
# role :db adds migration and whenever tasks
server "172.20.4.187", user: "sprc", roles: %w{app db web}

# app-02
# XXX without role :db to avoid whenever and migrations, which are already on app-01.
server "172.20.4.204", user: "sprc", roles: %w{app web}

# app-03
# XXX without role :db to avoid whenever and migrations, which are already on app-01.
#server "172.27.36.6", user: "sprc", roles: %w{app web}

# service-01
# XXX requires :web role to compile assets and send e-mails properly

server "172.20.4.182", user: "sprc", roles: %w{web sidekiq}
server "172.20.4.171", user: "sprc", roles: %w{web sidekiq_export}