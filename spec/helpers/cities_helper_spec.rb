require 'rails_helper'

describe CitiesHelper do

  context 'cities_by_state_for_select' do
    let(:state) { create(:state) }

    let!(:city_1) { create(:city, state: state) }
    let!(:city_2) { create(:city, state: state) }
    let!(:other) { create(:city) }

    let(:expected) do
      [
        [ city_1.name, city_1.id ],
        [ city_2.name, city_2.id ]
      ]
    end

    it { expect(cities_by_state_for_select(state.id)).to eq(expected) }
  end

end
