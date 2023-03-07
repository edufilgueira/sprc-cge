require 'rails_helper'

describe Transparency::Export::IntegrationResultsStrategicIndicatorPresenter do
  subject(:strategic_indicator_spreadsheet_presenter) do
    Transparency::Export::IntegrationResultsStrategicIndicatorPresenter.new(strategic_indicator)
  end

  let(:strategic_indicator) { create(:integration_results_strategic_indicator) }

  let(:klass) { Integration::Results::StrategicIndicator }

  it 'spreadsheet_header' do
    expected = [
      klass.human_attribute_name(:axis_title),
      klass.human_attribute_name(:resultado),
      klass.human_attribute_name(:indicador),
      klass.human_attribute_name(:unidade),
      klass.human_attribute_name(:sigla_orgao),
      klass.human_attribute_name(:orgao),
      klass.human_attribute_name(:valores_realizados),
      klass.human_attribute_name(:valores_atuais)
    ]

    expect(Transparency::Export::IntegrationResultsStrategicIndicatorPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      strategic_indicator.axis_title,
      strategic_indicator.resultado,
      strategic_indicator.indicador,
      strategic_indicator.unidade,
      strategic_indicator.sigla_orgao,
      strategic_indicator.orgao,
      strategic_indicator.valores_realizados,
      strategic_indicator.valores_atuais
    ]

    result = strategic_indicator_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
