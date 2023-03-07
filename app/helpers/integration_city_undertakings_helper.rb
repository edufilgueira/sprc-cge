module IntegrationCityUndertakingsHelper

  def integration_city_undertakings_expenses_for_select_with_all_option
    integration_city_undertakings_expenses_for_select.insert(0, [t('messages.filters.select.all.male'), ' '])
  end

  private

  def integration_city_undertakings_expenses_for_select
    Integration::CityUndertakings::CityUndertaking.expenses.keys.map do |status|
      [ I18n.t("integration/city_undertakings/city_undertaking.expenses.#{status}"), status ]
    end
  end

end
