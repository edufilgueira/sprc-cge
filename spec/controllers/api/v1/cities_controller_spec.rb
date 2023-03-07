require 'rails_helper'

describe Api::V1::CitiesController do
  include ResponseSpecHelper

  let(:state) { create(:state) }

  let!(:city_1) { create(:city, state: state) }
  let!(:city_2) { create(:city, state: state) }
  let!(:other) { create(:city) }

  describe '#index' do
    before do
      city_1
      city_2
      other

      get(:index, params: { state: state })
    end

    it { is_expected.to respond_with(:success) }
    it { expect(json.size).to eq(2) }

    it { expect(json[0]['id']).to eq(city_1.id) }
    it { expect(json[0]['name']).to eq(city_1.name) }
  end

end
