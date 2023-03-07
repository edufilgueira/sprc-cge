require 'rails_helper'

describe Api::V1::OrgansController do
  include ResponseSpecHelper

  let!(:organ) { create(:executive_organ) }

  describe '#index' do
    before { get(:index) }

    it { is_expected.to respond_with(:success) }
    it { expect(json[0]['id']).to eq organ.id }
    it { expect(json[0]['acronym']).to eq organ.acronym }
    it { expect(json[0]['name']).to eq organ.name }
  end

end
