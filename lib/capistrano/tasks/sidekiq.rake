# sidekiq tasks
namespace :sidekiq do
  %w(start stop restart).each do |command|
    Rake::Task["sidekiq:#{command}"].clear_actions if Rake::Task.tasks.include?("sidekiq:#{command}")
    desc "#{command} Sidekiq systemd daemon"
    task command do
      on roles fetch(:sidekiq_role) do
        execute :sudo, "#{fetch(:sidekiq_path)} #{command}"
      end
      on roles fetch(:sidekiq_export_role) do
        execute :sudo, "#{fetch(:sidekiq_exports_path)} #{command}"
      end
    end
  end

  Rake::Task['sidekiq:status'].clear_actions if Rake::Task.tasks.include?('sidekiq:status')
  desc "status Sidekiq systemd daemon"
  task :status do
    on roles fetch(:sidekiq_role) do
      execute :sudo, "#{fetch(:sidekiq_path)} status", raise_on_non_zero_exit: false
    end
    on roles fetch(:sidekiq_export_role) do
      execute :sudo, "#{fetch(:sidekiq_exports_path)} status", raise_on_non_zero_exit: false
    end
  end
end

after :'deploy', :'sidekiq:restart'
