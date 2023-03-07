#
# Atribui ExecutiveOrgan ao type do STI organ quando for nil
#

# cd /app/sprc/current && RAILS_ENV=production bundle exec rake executive_organs:create_or_update
namespace :executive_organs do
  task create_or_update: :environment do
    Organ.where(type: nil).each { |organ| organ.update(type: 'ExecutiveOrgan') }
  end
end
