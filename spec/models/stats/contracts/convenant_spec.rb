require 'rails_helper'

describe Stats::Contracts::Convenant do

  subject(:stats_contracts_convenant) { build(:stats_contracts_convenant) }

  it_behaves_like 'models/base'
  it_behaves_like 'models/timestamp'

  context 'inheritance' do
    it { is_expected.to be_a(Stat) }
  end
end
