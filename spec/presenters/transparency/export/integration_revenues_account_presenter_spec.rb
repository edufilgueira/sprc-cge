require 'rails_helper'

describe Transparency::Export::IntegrationRevenuesAccountPresenter do

  subject(:revenues_account_spreadsheet_presenter) do
    Transparency::Export::IntegrationRevenuesAccountPresenter.new(revenues_accounts)
  end

  let(:organ) { create(:integration_supports_organ, orgao_sfp: false) }

  let(:revenue_nature) { create(:integration_supports_revenue_nature, codigo: '112109953') }
  let(:revenue) { create(:integration_revenues_revenue, unidade: organ.codigo_orgao) }
  let(:revenues_account) { create(:integration_revenues_account, revenue: revenue, conta_corrente: "#{revenue_nature.codigo}.20500") }

  let(:transparency_export) { create(:transparency_export, :revenues_account) }

  let(:revenues_account_result_ids) { Integration::Revenues::Account.find_by_sql(transparency_export.query).pluck(:id) }

  let(:revenues_accounts) { Integration::Revenues::Account.where(id: revenues_account_result_ids) }

  let(:klass) { Integration::Revenues::Account }

  let(:columns) do
    [
      :title,
      :valor_previsto_inicial,
      :valor_previsto_atualizado,
      :valor_arrecadado
    ]
  end

  it 'spreadsheet_header' do
    expected = columns.map{ |column| I18n.t("integration/revenues/account.spreadsheet.worksheets.default.header.#{column}") }

    expect(Transparency::Export::IntegrationRevenuesAccountPresenter.spreadsheet_header).to eq(expected)
  end


  it 'spreadsheet_row' do
    revenues_account

    revenues_tree = Integration::Revenues::RevenuesTree.new(revenues_accounts)
    nodes = revenues_tree.nodes(:organ)

    expected = [
      nodes.first[:title],
      nodes.first[:valor_previsto_inicial],
      nodes.first[:valor_previsto_atualizado],
      nodes.first[:valor_arrecadado],
    ]

    result = revenues_account_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq([expected])
  end
end
