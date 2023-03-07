require 'rails_helper'

describe Api::V1::Integration::Supports::ServerRolesController do
  include ResponseSpecHelper

  let(:organ) { create(:integration_supports_organ, orgao_sfp: true, codigo_folha_pagamento: '1234') }
  let(:server_role) { create(:integration_supports_server_role) }

  describe '#index' do
    before { server_role && get(:index) }

    it { is_expected.to respond_with(:success) }
    it { expect(json[0]['id']).to eq server_role.id }
    it { expect(json[0]['name']).to eq server_role.name }

    describe 'filter' do
      it 'codigo_folha_pagamento' do
        create(:integration_supports_organ_server_role, organ: organ, role: server_role)

        another_server_role = create(:integration_supports_server_role)

        get(:index, params: {'codigo_folha_pagamento': organ.codigo_folha_pagamento})

        expect(json.length).to eq(1)
        expect(json[0]['id']).to eq(server_role.id)
      end
    end

    describe 'distinct' do
      it 'integration_supports_organ_id' do
        organ = create(:integration_supports_organ)
        create(:integration_supports_organ_server_role, organ: organ, role: server_role)

        another_organ = create(:integration_supports_organ)
        create(:integration_supports_organ_server_role, organ: another_organ, role: server_role)

        get(:index)

        expect(json.length).to eq(1)
        expect(json[0]['id']).to eq(server_role.id)
      end
    end
  end
end
