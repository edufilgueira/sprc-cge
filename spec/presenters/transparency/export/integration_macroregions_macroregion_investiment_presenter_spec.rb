require 'rails_helper'

describe Transparency::Export::IntegrationMacroregionsMacroregionInvestimentPresenter do
  subject(:investment_spreadsheet_presenter) do
    Transparency::Export::IntegrationMacroregionsMacroregionInvestimentPresenter.new(investment)
  end

  let(:investment) { create(:integration_macroregions_macroregion_investiment) }

  let(:klass) { Integration::Macroregions::MacroregionInvestiment }

  it 'spreadsheet_header' do
    expected = [
      klass.human_attribute_name(:ano_exercicio),
      klass.human_attribute_name(:codigo_poder),
      klass.human_attribute_name(:descricao_poder),
      klass.human_attribute_name(:codigo_regiao),
      klass.human_attribute_name(:descricao_regiao),
      klass.human_attribute_name(:valor_lei),
      klass.human_attribute_name(:valor_lei_creditos),
      klass.human_attribute_name(:valor_empenhado),
      klass.human_attribute_name(:valor_pago),
      klass.human_attribute_name(:perc_empenho),
      klass.human_attribute_name(:perc_pago_calculated)
    ]

    expect(Transparency::Export::IntegrationMacroregionsMacroregionInvestimentPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      investment.ano_exercicio,
      investment.codigo_poder,
      investment.descricao_poder,
      investment.codigo_regiao,
      investment.descricao_regiao,
      investment.valor_lei,
      investment.valor_lei_creditos,
      investment.valor_empenhado,
      investment.valor_pago,
      investment.perc_empenho,
      investment.perc_pago_calculated,
    ]

    result = investment_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
