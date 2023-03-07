require 'rails_helper'

describe Api::V1::SubnetsController do
  include ResponseSpecHelper

  let!(:subnet) { create(:subnet) }

  describe '#index' do
    describe 'default' do
      before { get(:index) }

      it { is_expected.to respond_with(:success) }
      it { expect(json[0]['id']).to eq subnet.id }
      it { expect(json[0]['name']).to eq subnet.title }
    end

    describe 'filter' do
      it 'organ_id' do
        create(:subnet)

        get(:index, params: {'organ_id': subnet.organ.id})

        expect(json.length).to eq(1)
        expect(json[0]['id']).to eq(subnet.id)
      end
    end
  end
end
