require 'rails_helper'

describe Integration::Constructions::Ders::Search do

  let!(:der2) { create(:integration_constructions_der) }

  it 'by id_obra' do
    der = create(:integration_constructions_der, id_obra: '123')
    ders = Integration::Constructions::Der.search(der.id_obra)

    expect(ders).to eq([der])
  end

  it 'by construtora' do
    der = create(:integration_constructions_der, construtora: 'H123')
    ders = Integration::Constructions::Der.search(der.construtora)

    expect(ders).to eq([der])
  end

  it 'by supervisora' do
    der = create(:integration_constructions_der, supervisora: 'empresa')
    ders = Integration::Constructions::Der.search(der.supervisora)

    expect(ders).to eq([der])
  end

  it 'by distrito' do
    der = create(:integration_constructions_der, distrito: 'sobral')
    ders = Integration::Constructions::Der.search(der.distrito)

    expect(ders).to eq([der])
  end

  it 'by programa' do
    der = create(:integration_constructions_der, programa: 'seduc')
    ders = Integration::Constructions::Der.search(der.programa)

    expect(ders).to eq([der])
  end

  it 'by servicos' do
    der = create(:integration_constructions_der, servicos: 'obra rodoviária')
    ders = Integration::Constructions::Der.search(der.servicos)

    expect(ders).to eq([der])
  end

  it 'by trecho' do
    der = create(:integration_constructions_der, trecho: 'trécho')
    ders = Integration::Constructions::Der.search('trecho')

    expect(ders).to eq([der])
  end

  it 'by numero_contrato_der' do
    der = create(:integration_constructions_der, numero_contrato_der: '789')
    ders = Integration::Constructions::Der.search(der.numero_contrato_der)

    expect(ders).to eq([der])
  end

  it 'by numero_contrato_sic' do
    der = create(:integration_constructions_der, numero_contrato_sic: '789')
    ders = Integration::Constructions::Der.search(der.numero_contrato_sic)

    expect(ders).to eq([der])
  end
end
