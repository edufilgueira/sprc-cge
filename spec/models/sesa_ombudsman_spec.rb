require 'rails_helper'

describe SesaOmbudsman do

  context 'inheritance' do
    it { is_expected.to be_a(Ombudsman) }
  end

  context 'default_scope' do
    let!(:executive) { create(:executive_ombudsman) }
    let!(:sesa) { create(:sesa_ombudsman) }

    it { expect(SesaOmbudsman.all).to eq([sesa]) }
  end
end
