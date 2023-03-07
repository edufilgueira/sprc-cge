require 'rails_helper'

describe Integration::Servers::ServerSalary::Search do

  subject(:server_salary) { create(:integration_servers_server_salary, registration: registration, organ: organ) }
  let(:registration) { create(:integration_servers_registration , :with_server) }
  let(:server) { registration.server }
  let(:organ) { create(:integration_supports_organ, codigo_orgao: '989898989898999', descricao_orgao: '98989898998-orgao', sigla: '989898-orgao', descricao_entidade: '8164646-orgao') }
  let(:role) { server_salary.role }

  subject(:not_found_server_salary) { create(:integration_servers_server_salary, registration: not_found_registration, server_name: 'not_found', role: not_found_role) }
  let(:not_found_registration) { create(:integration_servers_registration, server: not_found_server, organ: not_found_organ) }
  let(:not_found_server) { create(:integration_servers_server) }
  let(:not_found_organ) { create(:integration_supports_organ, codigo_orgao: 'not_found', descricao_orgao: 'not_found', sigla: 'not_found', descricao_entidade: 'not_found') }
  let(:not_found_role) { create(:integration_supports_server_role, name: 'not_found') }

  before do
    server_salary
    not_found_server_salary
  end

  it 'server_name' do
    server_salaries = Integration::Servers::ServerSalary.search(server_salary.server_name)
    expect(server_salaries).to eq([server_salary])
  end
end
