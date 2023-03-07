require 'rails_helper'

describe IntegrationResultsThematicIndicatorsHelper do

  let(:indicator) { create(:integration_results_thematic_indicator) }

  it 'thematic_indicators_table_header' do
    indicator
    freeze_header = ['descricao_eixo', 'descricao_tema', 'sigla', 'indicator', 'unidade']
    expected = (freeze_header << ((Date.today.year - 5)..Date.today.year - 1).map{|d| d.to_s}).flatten

    expect(thematic_indicators_table_header).to eq(expected)
  end

  it 'thematic_indicators_valores_realizados_years' do
    indicator
    expected = ['2012', '2013', '2014', '2015', '2016']

    expect(thematic_indicators_valores_realizados_years(indicator)).to eq(expected)
  end

  it 'thematic_indicators_valores_programados_years' do
    indicator
    expected = ['2016', '2017', '2018', '2019']

    expect(thematic_indicators_valores_programados_years(indicator)).to eq(expected)
  end
end
