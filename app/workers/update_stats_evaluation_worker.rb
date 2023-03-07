class UpdateStatsEvaluationWorker
  include Sidekiq::Worker
  sidekiq_options queue: :low

  def perform
    ['sou', 'sic', 'call_center', 'transparency'].each { |t| create_or_update(t) }
  end


  private

  def create_or_update(type)
    # atualizando também as estatísticas do mês anterio,
    # pois pode existir respostas e pesquisas passadas não ainda não avalidadas
    UpdateStatsEvaluation.call(date.last_month.year, date.last_month.month, type)
    UpdateStatsEvaluation.call(date.year, date.month, type)
  end

  def date
    Date.today
  end
end
