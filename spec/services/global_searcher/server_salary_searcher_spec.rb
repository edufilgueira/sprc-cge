require 'rails_helper'

describe GlobalSearcher::ServerSalarySearcher do

  let(:url_helper) do
    Rails.application.routes.url_helpers
  end

  let(:organ) { create(:integration_supports_organ, codigo_orgao: '989898989898999', descricao_orgao: '98989898998-orgao', sigla: '989898-orgao', descricao_entidade: '8164646-orgao') }
  let(:registration) { create(:integration_servers_registration , :with_server) }
  let(:server) { registration.server }
  let!(:found_server_salary) { create(:integration_servers_server_salary, registration: registration, organ: organ, server_name: server.dsc_funcionario) }

  it 'server_name' do
    expected_description = "#{found_server_salary.role_name} (#{found_server_salary.organ_sigla})"

    expected = {
      id: 'Integration::Servers::Server',

      results: [{
        title: found_server_salary.title,
        description: expected_description,
        link: url_helper.transparency_server_salary_path(found_server_salary, locale: I18n.locale)
      }],

      show_more_url: url_helper.transparency_server_salaries_path(search: found_server_salary.server_name, anchor: 'search', locale: I18n.locale)
    }

    result = GlobalSearcher.call(:server_salary, found_server_salary.server_name)

    expect(result).to eq(expected)
  end

  it 'limits to 15 results' do
    expect(GlobalSearcher::ServerSalarySearcher::SEARCH_LIMIT).to eq(15)
  end

  describe 'uniqueness' do
    it 'return the server' do
      create(:integration_servers_server, :with_salaries, dsc_funcionario: '1234')
      expect(GlobalSearcher::ServerSalarySearcher.call('23')[:results].count).to eq(1)
    end
  end
end
