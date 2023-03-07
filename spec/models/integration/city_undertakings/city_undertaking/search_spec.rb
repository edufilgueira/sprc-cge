require 'rails_helper'

describe Integration::CityUndertakings::CityUndertaking::Search do
  it { is_expected.to be_unaccent_searchable_like('integration_city_undertakings_city_undertakings.municipio') }
  it { is_expected.to be_unaccent_searchable_like('integration_city_undertakings_city_undertakings.mapp') }
  it { is_expected.to be_unaccent_searchable_like('integration_city_undertakings_city_undertakings.tipo_despesa') }
  it { is_expected.to be_unaccent_searchable_like('integration_supports_creditors.nome') }
end
