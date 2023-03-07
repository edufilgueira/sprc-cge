require 'rails_helper'

describe AccountConfigurationsHelper do
  it 'account_configurations_for_select' do
    create(:integration_revenues_account_configuration)

    expected = Integration::Revenues::AccountConfiguration.sorted.map do |acc|
      [acc.title, acc.id]
    end

    expect(account_configurations_for_select).to eq(expected)
  end
end
