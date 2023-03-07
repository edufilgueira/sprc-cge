require 'rails_helper'

describe Integration::Constructions::Daes::Search do

  let!(:dae) { create(:integration_constructions_dae) }

  it 'by id_obra' do
    dae = create(:integration_constructions_dae, id_obra: '123')
    daes = Integration::Constructions::Dae.search(dae.id_obra)

    expect(daes).to eq([dae])
  end

  it 'by codigo_obra' do
    dae = create(:integration_constructions_dae, codigo_obra: 'H123')
    daes = Integration::Constructions::Dae.search(dae.codigo_obra)

    expect(daes).to eq([dae])
  end

  it 'by contratada' do
    dae = create(:integration_constructions_dae, contratada: 'empresa')
    daes = Integration::Constructions::Dae.search(dae.contratada)

    expect(daes).to eq([dae])
  end

  it 'by municipio' do
    dae = create(:integration_constructions_dae, municipio: 'sobral')
    daes = Integration::Constructions::Dae.search(dae.municipio)

    expect(daes).to eq([dae])
  end

  it 'by secretaria' do
    dae = create(:integration_constructions_dae, secretaria: 'seduc')
    daes = Integration::Constructions::Dae.search(dae.secretaria)

    expect(daes).to eq([dae])
  end

  it 'by descricao' do
    dae = create(:integration_constructions_dae, descricao: 'obra para a criação')
    daes = Integration::Constructions::Dae.search(dae.descricao)

    expect(daes).to eq([dae])
  end

  it 'by numero_sacc' do
    dae = create(:integration_constructions_dae, numero_sacc: '789')
    daes = Integration::Constructions::Dae.search(dae.numero_sacc)

    expect(daes).to eq([dae])
  end

end
