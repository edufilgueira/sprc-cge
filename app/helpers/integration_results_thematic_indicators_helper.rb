module IntegrationResultsThematicIndicatorsHelper

  def thematic_indicators_table_header
    freeze_header = ['descricao_eixo', 'descricao_tema', 'sigla', 'indicator', 'unidade']

    thematic_indicators_years.each { |y| freeze_header << "#{y}" }

    freeze_header
  end

  def thematic_indicators_years
    (Date.today.year - 5)..Date.today.year - 1
  end

  def thematic_indicators_valores_realizados_years(indicator)
    return [] if indicator.valores_realizados.blank?

    indicator.valores_realizados['valor_realizado'].map { |i| i['ano'] if i.is_a?(Hash) }.sort
  end

  def thematic_indicators_valores_programados_years(indicator)
    return [] if indicator.valores_programados.blank?

    indicator.valores_programados['valor_programado'].map { |i| i['ano'] if i.is_a?(Hash) }.sort
  end
end
