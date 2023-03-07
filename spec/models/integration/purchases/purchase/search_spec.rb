require 'rails_helper'

describe Integration::Purchases::Purchase::Search do

  let!(:purchase) do
    create(:integration_purchases_purchase,
      numero_publicacao: 999999,
      descricao_item: 'NOVO EXTRATOR DE GRAMPOS',
      codigo_item: 12345,
      nome_fornecedor:'CAIENA LTDA',
      nome_resp_compra: 'NOVO HOSPITAL DE SAUDE MENTAL DE MESSEJANA',
      natureza_aquisicao: 'NOVO MATERIAL DE CONSUMO',
      nome_grupo: 'NOVOS ARTIGOS E UTENSILIOS DE ESCRITORIO'
    )
  end

  let!(:another_purchase) { create(:integration_purchases_purchase) }

  it 'numero_publicacao' do
    purchases = Integration::Purchases::Purchase.search(purchase.numero_publicacao)
    expect(purchases).to eq([purchase])
  end

  it 'descricao_item' do
    purchases = Integration::Purchases::Purchase.search(purchase.descricao_item)
    expect(purchases).to eq([purchase])
  end

  it 'codigo_item' do
    purchases = Integration::Purchases::Purchase.search(purchase.codigo_item)
    expect(purchases).to eq([purchase])
  end

  it 'nome_fornecedor' do
    purchases = Integration::Purchases::Purchase.search(purchase.nome_fornecedor)
    expect(purchases).to eq([purchase])
  end

  it 'nome_resp_compra' do
    purchases = Integration::Purchases::Purchase.search(purchase.nome_resp_compra)
    expect(purchases).to eq([purchase])
  end

  it 'natureza_aquisicao' do
    purchases = Integration::Purchases::Purchase.search(purchase.natureza_aquisicao)
    expect(purchases).to eq([purchase])
  end

  it 'nome_grupo' do
    purchases = Integration::Purchases::Purchase.search(purchase.nome_grupo)
    expect(purchases).to eq([purchase])
  end
end
