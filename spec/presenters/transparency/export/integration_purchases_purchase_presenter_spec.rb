require 'rails_helper'

describe Transparency::Export::IntegrationPurchasesPurchasePresenter do
  subject(:purchase_spreadsheet_presenter) do
    Transparency::Export::IntegrationPurchasesPurchasePresenter.new(purchase)
  end

  let(:purchase) { create(:integration_purchases_purchase) }


  let(:klass) { Integration::Purchases::Purchase }

  it 'spreadsheet_header' do
    expected = [
      klass.human_attribute_name(:numero_publicacao),
      klass.human_attribute_name(:nome_resp_compra),
      klass.human_attribute_name(:nome_fornecedor),
      klass.human_attribute_name(:descricao_item),
      klass.human_attribute_name(:quantidade_estimada),
      klass.human_attribute_name(:valor_unitario),
      klass.human_attribute_name(:valor_total_calculated)
    ]

    expect(Transparency::Export::IntegrationPurchasesPurchasePresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      purchase.numero_publicacao,
      purchase.nome_resp_compra,
      purchase.nome_fornecedor,
      purchase.descricao_item,
      purchase.quantidade_estimada,
      purchase.valor_unitario,
      purchase.valor_total_calculated
    ]

    result = purchase_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
