# defining delayed job tasks
namespace :passenger do

  desc "Restarts Passenger (and the app)"
  task :restart do
    on roles(:app) do
      with_rvm = "#{fetch(:rvm_path)}/bin/rvm #{fetch(:passenger_rvm_ruby_version)} do"
      execute "#{with_rvm} passenger-config restart-app #{deploy_to} --ignore-app-not-running"
    end
  end

end


namespace :load do
  task :defaults do
    set :passenger_rvm_ruby_version, -> { fetch(:rvm_ruby_version) }
  end
end


# auto hooking after publishing
after :'deploy:publishing', :'passenger:restart'
