require 'rails_helper'

describe Integration::Supports::Organ::Search do
  it 'descricao_orgao' do
    organ = create(:integration_supports_organ, descricao_orgao: 'HOSPITAL GERAL DA POLÍCIA MILITAR JOSÉ MARTINIANO DE ALENCAR')
    another_organ = create(:integration_supports_organ, descricao_orgao: 'SUPERINDENT DO DESENV URBANO DO ESTADO DO CEARA')
    another_organ
    organs = Integration::Supports::Organ.search('HOSP')
    expect(organs).to eq([organ])
  end

  it 'codigo_orgao' do
    organ = create(:integration_supports_organ, codigo_orgao: '123')
    another_organ = create(:integration_supports_organ, codigo_orgao: '321')
    another_organ
    organs = Integration::Supports::Organ.search('123')
    expect(organs).to eq([organ])
  end

  it 'sigla' do
    organ = create(:integration_supports_organ, sigla: 'PM')
    another_organ = create(:integration_supports_organ, sigla: 'ARCE')
    another_organ
    organs = Integration::Supports::Organ.search('PM')
    expect(organs).to eq([organ])
  end
end
