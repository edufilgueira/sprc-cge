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

set :stage_sidekiq_path, 'service sprc.sidekiq'
set :stage_sidekiq_exports_path, 'service sprc.sidekiq.exports'

# app-01
# role :db adds migration and whenever tasks
server "172.27.40.39", user: "sprc", roles: %w{app db web sidekiq }
