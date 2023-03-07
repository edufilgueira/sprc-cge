require 'rails_helper'

describe IntegrationServersHelper do

  it 'integration_server_roles_for_select' do
    first = create(:integration_supports_server_role, name: 'Cargo 1')
    second = create(:integration_supports_server_role, name: 'A Cargo')

    expected = [
      [second.name, second.id],
      [first.name, first.id]
    ]

    expect(integration_server_roles_for_select).to eq(expected)
  end

  it 'integration_server_roles_for_select_with_all_option' do
    first = create(:integration_supports_server_role, name: 'Cargo 1')
    second = create(:integration_supports_server_role, name: 'A Cargo')

    expected = [
      [I18n.t('shared.servers.filters.roles'), ' '],
      [second.name, second.id],
      [first.name, first.id]
    ]

    expect(integration_server_roles_for_select_with_all_option).to eq(expected)
  end
end
