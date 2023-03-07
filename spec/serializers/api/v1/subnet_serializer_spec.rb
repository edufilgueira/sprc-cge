require 'rails_helper'

describe Api::V1::SubnetSerializer do

  let(:subnet) { create(:subnet) }

  let(:subnet_serializer) do
    Api::V1::SubnetSerializer.new(subnet)
  end

  let(:subnet_serialization) do
    ActiveModelSerializers::Adapter.create(subnet_serializer)
  end

  subject(:subnet_json) do
    JSON.parse(subnet_serialization.to_json)
  end

  describe 'attributes' do
    it { expect(subnet_json['id']).to eq(subnet.id) }
    it { expect(subnet_json['acronym']).to eq(subnet.acronym) }
    it { expect(subnet_json['name']).to eq(subnet.title) }
  end

end
