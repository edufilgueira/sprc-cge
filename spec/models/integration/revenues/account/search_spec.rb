require 'rails_helper'

describe Integration::Revenues::Account::Search do
  it { is_expected.to be_searchable_like('integration_supports_organs.sigla') }
  it { is_expected.to be_searchable_like('integration_supports_organs.descricao_entidade') }
  it { is_expected.to be_searchable_like('integration_supports_organs.descricao_orgao') }
  it { is_expected.to be_searchable_like('integration_supports_revenue_natures.descricao') }
end
