require 'rails_helper'

describe IntegrationResultsStrategicIndicatorsHelper do

  let(:indicator) { create(:integration_results_strategic_indicator) }

  it 'strategic_indicators_table_header' do
    indicator
    freeze_header = ['descricao_eixo', 'sigla', 'indicator', 'unidade']
    expected = (freeze_header << ((Date.today.year - 4)..Date.today.year - 2).map{|d| d.to_s}).flatten

    expect(strategic_indicators_table_header).to eq(expected)
  end

  it 'strategic_indicators_valores_realizados_years' do
    indicator
    expected = ['2012', '2013', '2014']

    expect(strategic_indicators_valores_realizados_years(indicator)).to eq(expected)
  end

  it 'strategic_indicators_valores_atuais_years' do
    indicator
    expected = []

    expect(strategic_indicators_valores_atuais_years(indicator)).to eq(expected)
  end
end
