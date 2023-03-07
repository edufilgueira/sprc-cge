require 'rails_helper'

describe Stats::Revenues::RegisteredRevenue do

  subject(:stats_revenues_registered_revenue) { build(:stats_revenues_registered_revenue) }

  it_behaves_like 'models/base'
  it_behaves_like 'models/timestamp'

  context 'inheritance' do
    it { is_expected.to be_a(Stat) }
  end
end
