require 'rails_helper'

describe Integration::Expenses::Nld::Search do

  it { is_expected.to be_searchable_like('integration_expenses_nlds.numero') }
  it { is_expected.to be_searchable_like('integration_expenses_nlds.credor') }
  it { is_expected.to be_searchable_like('integration_expenses_nlds.unidade_gestora') }
  it { is_expected.to be_searchable_like('integration_supports_creditors.nome') }

end
