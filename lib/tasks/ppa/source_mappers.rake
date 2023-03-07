namespace :ppa do
  namespace :source_mappers do

    desc 'Destroys all source mapping PPA data'
    task clear: :environment do |task|
      logger = Logger.new STDOUT, progname: "rake #{task.name}"

      logger.info "starting..."

      PPA::SourceMapper.destroy_all

      logger.info "complete"
    end

    desc 'Loads - creating and/or updating - all source mapping PPA data'
    task load: :environment do |task|
      logger = Logger.new STDOUT, progname: "rake #{task.name}"

      logger.info "starting..."

      PPA::SourceMapper.map_all

      logger.info "complete"
    end

    desc 'Resets the source mapping PPA data'
    task reset: :environment do |task|
      logger = Logger.new STDOUT, progname: "rake #{task.name}"

      logger.info "starting..."

      # Repetindo o uso dos orquestradores - e não reutilizando as rakes :load e :clear - para que
      # o logging fique contextualizado na rake task!
      PPA::SourceMapper.destroy_all
      PPA::SourceMapper.map_all

      logger.info "complete"
    end

  end
end
