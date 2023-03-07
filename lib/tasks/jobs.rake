require 'sidekiq/api'

namespace :jobs do
  task clear: :environment do
    # flush sidekiq redis db
    Sidekiq.redis { |conn| conn.flushdb }

    # 1. Clear retry set
    Sidekiq::RetrySet.new.clear

    # 2. Clear scheduled jobs
    Sidekiq::ScheduledSet.new.clear

    # 3. Clear 'Processed' and 'Failed' jobs statistics (OPTIONAL)
    # Sidekiq::Stats.new.reset
  end
end
