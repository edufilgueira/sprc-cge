require 'rails_helper'

describe Transparency::Constructions::DaesController do

  describe '#index' do
    it_behaves_like 'controllers/transparency/constructions/daes/index'

    describe 'helper_methods' do
      it 'coordinates' do
        dae_attributes = {
          secretaria: 'SEDUC',
          contratada: 'FORTEKS',
          descricao: 'Conclusão',
          municipio: 'FORTALEZA',
          valor: '906844.37',
          status: 'Em Execução',
          latitude: '12.345',
          longitude: '-12.345'
        }

        dae = create(:integration_constructions_dae, dae_attributes)
        create(:integration_constructions_dae, latitude: nil, longitude: nil)

        get(:index)

        expected = [dae].as_json(only: [
          :id,
          :secretaria,
          :contratada,
          :descricao,
          :municipio,
          :status,
          :valor,
          :latitude,
          :longitude
        ])

        expect(controller.coordinates).to match(expected)
      end
    end
  end

  describe '#show' do
    let(:dae) { create(:integration_constructions_dae) }
    let(:url) { transparency_constructions_dae_url(dae) }

    it_behaves_like 'controllers/transparency/constructions/daes/show'
  end

end
