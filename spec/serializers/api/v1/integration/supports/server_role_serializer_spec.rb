require 'rails_helper'

describe Api::V1::Integration::Supports::ServerRoleSerializer do

  let(:server_role) { create(:integration_supports_server_role) }

  let(:server_role_serializer) do
    Api::V1::Integration::Supports::ServerRoleSerializer.new(server_role)
  end

  let(:server_role_serialization) do
    ActiveModelSerializers::Adapter.create(server_role_serializer)
  end

  subject(:server_role_json) do
    JSON.parse(server_role_serialization.to_json)
  end

  describe 'attributes' do
    it { expect(server_role_json['id']).to eq(server_role.id) }
    it { expect(server_role_json['name']).to eq(server_role.name) }
  end
end
