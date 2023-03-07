require 'rails_helper'

describe Stats::Revenues::Account do

  subject(:stats_revenues_account) { build(:stats_revenues_account) }

  it_behaves_like 'models/base'
  it_behaves_like 'models/timestamp'

  context 'inheritance' do
    it { is_expected.to be_a(Stat) }
  end
end
