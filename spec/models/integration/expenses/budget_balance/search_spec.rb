require 'rails_helper'

describe Integration::Expenses::BudgetBalance::Search do
  it { is_expected.to be_unaccent_searchable_like('integration_supports_organs.descricao_entidade') }
  it { is_expected.to be_unaccent_searchable_like('integration_supports_organs.descricao_orgao') }
  it { is_expected.to be_unaccent_searchable_like('integration_supports_functions.titulo') }
  it { is_expected.to be_unaccent_searchable_like('integration_supports_sub_functions.titulo') }
  it { is_expected.to be_unaccent_searchable_like('integration_supports_government_programs.titulo') }
  it { is_expected.to be_unaccent_searchable_like('integration_supports_government_actions.titulo') }
  it { is_expected.to be_unaccent_searchable_like('integration_supports_administrative_regions.titulo') }
  it { is_expected.to be_unaccent_searchable_like('integration_supports_expense_natures.titulo') }
  it { is_expected.to be_unaccent_searchable_like('integration_supports_qualified_resource_sources.titulo') }
  it { is_expected.to be_unaccent_searchable_like('integration_supports_finance_groups.titulo') }
end
