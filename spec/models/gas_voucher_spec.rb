require 'rails_helper'

describe GasVoucher do

  subject(:gas_voucher) { build(:gas_voucher) }

  describe 'return any lot' do
  	 it { expect(gas_voucher.lot).to eq("LOTE 02") }
  end

  describe 'factories' do
  	it { is_expected.to be_valid }
  end
end