namespace :data_fixes do
  #
  # Data fix para atualizar a forma de calcular a média da pesquisa de satisfação
  #
  # A pedido da CGE a média aritmética deve considerar apenas todos os itens da questão 1
  #
  # RAILS_ENV=production bundle rails rake data_fixes:update_average_evaluation
  task update_average_evaluation: :environment do

    # update_column para evitar a redundância do callback "after_validation :calculate_average"
    Evaluation.all.each { |evaluation| evaluation.update_column(:average, calculate_average(evaluation)) }
  end

  # RAILS_ENV=production bundle rails rake data_fixes:update_stats_evaluation
  task update_stats_evaluation: :environment do

    (6..12).each do |month|
      ['sic', 'sou', 'call_center'].each { |type| UpdateStatsEvaluation.delay.call(2018, month, type)}
    end

    ['sic', 'sou', 'call_center'].each { |type| UpdateStatsEvaluation.delay.call(2019, 1, type)}
  end

  #
  # extraído do método privado Evaluation#calculate_average
  #
  def calculate_average(evaluation)
    summable_attributes = [evaluation.question_01_a, evaluation.question_01_b, evaluation.question_01_c, evaluation.question_01_d]

    return if summable_attributes.any?(&:blank?)

    questions_sum = summable_attributes.sum

    questions_sum / 4.0
  end
end
