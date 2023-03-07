require 'rails_helper'

describe Transparency::Export::IntegrationRevenuesTransferPresenter do
  subject(:revenues_transfer_spreadsheet_presenter) do
    Transparency::Export::IntegrationRevenuesTransferPresenter.new(revenues_transfers)
  end

  let(:organ) { create(:integration_supports_organ, orgao_sfp: false) }

  let(:non_transfer_revenue_nature) { create(:integration_supports_revenue_nature, codigo: '123') }
  let(:revenue) { create(:integration_revenues_revenue, unidade: organ.codigo_orgao) }
  let(:transfer_required_revenue_nature) { create(:integration_supports_revenue_nature, codigo: Integration::Supports::RevenueNature::TRANSFER_CODES[:required].first) }
  let(:revenues_transfer) { create(:integration_revenues_transfer, conta_corrente: transfer_required_revenue_nature.codigo, revenue: revenue) }

  let(:transparency_export) { create(:transparency_export, :revenues_transfer) }

  let(:revenues_transfer_result_ids) { Integration::Revenues::Transfer.find_by_sql(transparency_export.query).pluck(:id) }

  let(:revenues_transfers) { Integration::Revenues::Transfer.where(id: revenues_transfer_result_ids) }

  let(:klass) { Integration::Revenues::Transfer }

  let(:columns) do
    [
      :title,
      :valor_previsto_inicial,
      :valor_previsto_atualizado,
      :valor_arrecadado
    ]
  end

  it 'spreadsheet_header' do
    expected = columns.map{ |column| I18n.t("integration/revenues/transfer.spreadsheet.worksheets.default.header.#{column}") }

    expect(Transparency::Export::IntegrationRevenuesTransferPresenter.spreadsheet_header).to eq(expected)
  end


  it 'spreadsheet_row' do
    revenues_transfer

    revenues_tree = Integration::Revenues::TransfersTree.new(revenues_transfers)

    nodes = revenues_tree.nodes(:organ)

    expected = [
      nodes.first[:title],
      nodes.first[:valor_previsto_inicial],
      nodes.first[:valor_previsto_atualizado],
      nodes.first[:valor_arrecadado],
    ]

    result = revenues_transfer_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq([expected])
  end
end
