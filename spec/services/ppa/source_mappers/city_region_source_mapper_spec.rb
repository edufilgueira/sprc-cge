require 'rails_helper'

describe PPA::SourceMappers::CityRegionSourceMapper do


  describe '::map' do
    # avoid default scoped city error
    before { create :ppa_city }

    let!(:source) { PPA::Source::CityRegion.all.first }
    let(:region) { create :ppa_region, name: source.region_name }
    let(:city)    { create :ppa_city, name: source.city_name, code: source.city_code }

    subject(:map) { described_class.map source }


    context 'when the target City does not exist' do
      before { region }

      # verifica City em vez de PPA::City pois count é
      # um método privado em PPA::City
      it 'does nothing' do
        expect { map }.not_to change { City.count }
      end
    end

    context 'when the target Region does not exist' do
      before do
        city
        map
      end

      it 'does nothing' do
        expect(city.ppa_region_id).to be_nil
      end
    end

    context 'when PPA::Region already exists and the target PPA::City exists' do
      before do
        region
        city
      end

      it 'updates the target PPA::City' do
        expect do
          map
          city.reload
        end.to change { City.count }.by(0) # não cria nenhum registro
          .and change { city.ppa_region_id }.to(region.id)
      end
    end
  end

end
