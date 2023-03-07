require 'rails_helper'

describe Integration::Revenues::RegisteredRevenue do

  subject(:integration_revenues_registered_revenue) { build(:integration_revenues_registered_revenue) }

  # RegisteredRevenue é um tipo de Revenue mas para 'Receitas Lançadas'

  it { is_expected.to be_kind_of(Integration::Revenues::Revenue) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_revenues_registered_revenue, :invalid)).to be_invalid }
  end

  describe 'scope' do
    it 'default_scope' do
      non_registered_revenue = create(:integration_revenues_revenue, conta_contabil: '5.2.1.1.1')
      registered_revenue = create(:integration_revenues_registered_revenue, conta_contabil: '4.1.1.2.1.03.01')

      expect(Integration::Revenues::Revenue.count).to eq(2)

      expect(Integration::Revenues::RegisteredRevenue.count).to eq(1)
      expect(Integration::Revenues::RegisteredRevenue.all).to match_array([registered_revenue])
    end
  end
end
