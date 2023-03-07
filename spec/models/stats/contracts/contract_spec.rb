require 'rails_helper'

describe Stats::Contracts::Contract do

  subject(:stats_contracts_contract) { build(:stats_contracts_contract) }

  it_behaves_like 'models/base'
  it_behaves_like 'models/timestamp'

  context 'inheritance' do
    it { is_expected.to be_a(Stat) }
  end
end
