module IntegrationResultsStrategicIndicatorsHelper

  def strategic_indicators_table_header
    freeze_header = ['descricao_eixo', 'sigla', 'indicator', 'unidade']

    strategic_indicators_last_years.each { |y| freeze_header << "#{y}" }

    freeze_header
  end

  def strategic_indicators_last_years
    (Date.today.year - 5)..Date.today.year - 1 
  end

  def strategic_indicators_valores_realizados_years(indicator)
    return [] if indicator.valores_realizados.blank?

    indicator.valores_realizados['valor_realizado'].map { |i| i['ano'] if i.is_a?(Hash) }.sort
  end

  def strategic_indicators_valores_atuais_years(indicator)
    return [] if indicator.valores_atuais.blank?

    indicator.valores_atuais['valores_atual'].map { |i| i['ano'] if i.is_a?(Hash) }.sort
  end
end
