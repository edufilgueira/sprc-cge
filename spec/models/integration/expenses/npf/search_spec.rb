require 'rails_helper'

describe Integration::Expenses::Npf::Search do

  it { is_expected.to be_searchable_like('integration_expenses_npfs.numero') }
  it { is_expected.to be_searchable_like('integration_expenses_npfs.credor') }
  it { is_expected.to be_searchable_like('integration_expenses_npfs.unidade_gestora') }
  it { is_expected.to be_searchable_like('integration_supports_creditors.nome') }

end
