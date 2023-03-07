require 'rails_helper'

describe Stats::Revenues::Transfer do

  subject(:stats_revenues_transfer) { build(:stats_revenues_transfer) }

  it_behaves_like 'models/base'
  it_behaves_like 'models/timestamp'

  context 'inheritance' do
    it { is_expected.to be_a(Stat) }
  end
end
