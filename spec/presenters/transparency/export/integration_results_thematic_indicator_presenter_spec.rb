require 'rails_helper'

describe Transparency::Export::IntegrationResultsThematicIndicatorPresenter do
  subject(:thematic_indicator_spreadsheet_presenter) do
    Transparency::Export::IntegrationResultsThematicIndicatorPresenter.new(thematic_indicator)
  end

  let(:thematic_indicator) { create(:integration_results_thematic_indicator) }

  let(:klass) { Integration::Results::ThematicIndicator }

  it 'spreadsheet_header' do
    expected = [
      klass.human_attribute_name(:axis_title),
      klass.human_attribute_name(:theme_title),
      klass.human_attribute_name(:resultado),
      klass.human_attribute_name(:indicador),
      klass.human_attribute_name(:unidade),
      klass.human_attribute_name(:sigla_orgao),
      klass.human_attribute_name(:orgao),
      klass.human_attribute_name(:valores_realizados),
      klass.human_attribute_name(:valores_programados)
    ]

    expect(Transparency::Export::IntegrationResultsThematicIndicatorPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      thematic_indicator.axis_title,
      thematic_indicator.theme_title,
      thematic_indicator.resultado,
      thematic_indicator.indicador,
      thematic_indicator.unidade,
      thematic_indicator.sigla_orgao,
      thematic_indicator.orgao,
      thematic_indicator.valores_realizados,
      thematic_indicator.valores_programados
    ]

    result = thematic_indicator_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
