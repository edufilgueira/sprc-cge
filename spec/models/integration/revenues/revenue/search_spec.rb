require 'rails_helper'

describe Integration::Revenues::Revenue::Search do

  let!(:revenue) { create(:integration_revenues_revenue) }
  let!(:another_revenue) { create(:integration_revenues_revenue) }

  it 'poder' do
    revenues = Integration::Revenues::Revenue.search(revenue.poder)
    expect(revenues).to eq([revenue])
  end
  it 'titulo' do
    revenues = Integration::Revenues::Revenue.search(revenue.titulo)
    expect(revenues).to eq([revenue])
  end
  it 'administracao' do
    revenues = Integration::Revenues::Revenue.search(revenue.administracao)
    expect(revenues).to eq([revenue])
  end
end
