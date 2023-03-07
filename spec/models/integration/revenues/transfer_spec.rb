require 'rails_helper'

describe Integration::Revenues::Transfer do

  subject(:integration_revenues_transfer) { build(:integration_revenues_transfer) }

  # Transfer é um tipo de Account que possua natureza da receita com transfer_required
  # transfer_voluntary.
  it { is_expected.to be_kind_of(Integration::Revenues::Account) }



  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_revenues_account, :invalid)).to be_invalid }
  end

  describe 'scope' do
    it 'default_scope' do
      non_transfer_revenue_nature = create(:integration_supports_revenue_nature, codigo: '123')
      transfer_required_revenue_nature = create(:integration_supports_revenue_nature, codigo: Integration::Supports::RevenueNature::TRANSFER_CODES[:required].first)
      transfer_voluntary_revenue_nature = create(:integration_supports_revenue_nature, codigo: Integration::Supports::RevenueNature::TRANSFER_CODES[:voluntary].first)


      non_transfer = create(:integration_revenues_account, conta_corrente: non_transfer_revenue_nature.codigo)
      transfer_required = create(:integration_revenues_transfer, conta_corrente: transfer_required_revenue_nature.codigo)
      transfer_voluntary = create(:integration_revenues_transfer, conta_corrente: transfer_voluntary_revenue_nature.codigo)

      expect(Integration::Revenues::Account.count).to eq(3)

      expect(Integration::Revenues::Transfer.count).to eq(2)
      expect(Integration::Revenues::Transfer.all).to match_array([transfer_required, transfer_voluntary])
    end
  end
end
