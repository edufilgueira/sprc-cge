require 'rails_helper'

describe Api::V1::OrganSerializer do

  let(:organ) { create(:executive_organ) }

  let(:organ_serializer) do
    Api::V1::OrganSerializer.new(organ)
  end

  let(:organ_serialization) do
    ActiveModelSerializers::Adapter.create(organ_serializer)
  end

  subject(:organ_json) do
    JSON.parse(organ_serialization.to_json)
  end

  describe 'attributes' do
    it { expect(organ_json['id']).to eq(organ.id) }
    it { expect(organ_json['acronym']).to eq(organ.acronym) }
    it { expect(organ_json['name']).to eq(organ.name) }
  end

end
