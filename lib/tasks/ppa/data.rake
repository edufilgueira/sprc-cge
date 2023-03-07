namespace :ppa do
  namespace :data do

    desc 'Destroys all PPA processed data'
    task clear: :environment do |task|
      logger = Logger.new STDOUT, progname: "rake #{task.name}"

      logger.info "starting..."

      PPA::DataLoader.destroy_all

      logger.info "complete"
    end

    desc 'Loads - creating and/or updating - all PPA processed data'
    task load: :environment do |task|
      logger = Logger.new STDOUT, progname: "rake #{task.name}"

      logger.info "starting..."

      PPA::DataLoader.load_all

      logger.info "complete"
    end

    desc 'Resets the processed PPA data'
    task reset: :environment do |task|
      logger = Logger.new STDOUT, progname: "rake #{task.name}"

      logger.info "starting..."

      # Repetindo o uso dos orquestradores - e não reutilizando as rakes :load e :clear - para que
      # o logging fique contextualizado na rake task!
      PPA::DataLoader.destroy_all
      PPA::DataLoader.load_all

      logger.info "complete"
    end

  end
end
