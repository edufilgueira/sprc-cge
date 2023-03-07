namespace :ppa do
  namespace :calculators do

    desc 'Destroys all calculated/aggregated PPA data'
    task clear: :environment do |task|
      logger = Logger.new STDOUT, progname: "rake #{task.name}"

      logger.info "starting..."

      PPA::Calculator.destroy_all

      logger.info "complete"
    end

    desc 'Loads - creating and/or updating - all calculated/aggregated PPA data'
    task load: :environment do |task|
      logger = Logger.new STDOUT, progname: "rake #{task.name}"

      logger.info "starting..."

      PPA::Calculator.calculate_all

      logger.info "complete"
    end

    desc 'Resets the calculated/aggregated PPA data'
    task reset: :environment do |task|
      logger = Logger.new STDOUT, progname: "rake #{task.name}"

      logger.info "starting..."

      # Repetindo o uso dos orquestradores - e não reutilizando as rakes :load e :clear - para que
      # o logging fique contextualizado na rake task!
      PPA::Calculator.destroy_all
      PPA::Calculator.calculate_all

      logger.info "complete"
    end

  end
end
