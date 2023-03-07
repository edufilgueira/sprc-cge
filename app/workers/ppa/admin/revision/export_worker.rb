class PPA::Admin::Revision::ExportWorker
  include Sidekiq::Worker
  
  
  def perform(plan_id)
    puts 'genrando arquivo'
  end
end
