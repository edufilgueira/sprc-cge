require 'rails_helper'

describe Integration::Expenses::Ned::Search do
  it { is_expected.to be_searchable_like('integration_expenses_neds.numero') }
  it { is_expected.to be_searchable_like('integration_expenses_neds.cpf_cnpj_credor') }
  it { is_expected.to be_unaccent_searchable_like('integration_expenses_neds.razao_social_credor') }
  it { is_expected.to be_searchable_like('integration_expenses_neds.unidade_gestora') }
  it { is_expected.to be_searchable_like('integration_supports_management_units.sigla') }
end
