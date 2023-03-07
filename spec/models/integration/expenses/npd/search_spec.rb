require 'rails_helper'

describe Integration::Expenses::Npd::Search do

  it { is_expected.to be_searchable_like('integration_expenses_npds.numero') }
  it { is_expected.to be_searchable_like('integration_expenses_npds.credor') }
  it { is_expected.to be_searchable_like('integration_expenses_npds.unidade_gestora') }
  it { is_expected.to be_searchable_like('integration_supports_creditors.nome') }
  it { is_expected.to be_searchable_like('integration_supports_management_units.sigla') }
  it { is_expected.to be_searchable_like('integration_supports_management_units.titulo') }

end
