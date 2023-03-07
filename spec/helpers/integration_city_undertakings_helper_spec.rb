require 'rails_helper'

describe IntegrationCityUndertakingsHelper do

  it 'integration_city_undertakings_expenses_for_select_with_all_option' do
    expected =
      Integration::CityUndertakings::CityUndertaking.expenses.keys.map do |status|
        [ I18n.t("integration/city_undertakings/city_undertaking.expenses.#{status}"), status ]
      end.insert(0, [t('messages.filters.select.all.male'), ' '])

    expect(integration_city_undertakings_expenses_for_select_with_all_option).to eq(expected)
  end
end
