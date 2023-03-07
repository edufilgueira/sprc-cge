require 'rails_helper'

describe Transparency::Constructions::DersController do

  describe '#index' do
    it_behaves_like 'controllers/transparency/constructions/ders/index'

    describe 'helper_methods' do
      it 'coordinates' do
        der_attributes = {
          construtora: 'SAMARIA',
          distrito: '04 - LIMOEIRO DO NORTE',
          programa: 'Ceará III (004)',
          servicos: 'Restauração: Entr° BR-116 - Palhano',
          status: 'CONCLUÍDO',
          trecho: 'ENTR. BR-116 - PALHANO',
          valor_aprovado: '906844.37',
          latitude: '12.345',
          longitude: '-12.345'
        }

        der = create(:integration_constructions_der, der_attributes)
        create(:integration_constructions_der, latitude: nil, longitude: nil)

        get(:index)

        expected = [der].as_json(only: [
          :id,
          :construtora,
          :distrito,
          :programa,
          :servicos,
          :status,
          :trecho,
          :valor_aprovado,
          :latitude,
          :longitude
        ])

        expect(controller.coordinates).to match(expected)
      end
    end
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/constructions/ders/show'
  end

end
