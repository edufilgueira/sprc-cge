require 'rails_helper'

describe Transparency::Covid19::GasVouchersController do
  describe '#index' do
    let(:gas_voucher) { create(:gas_voucher) }
    before { get(:index ) }

    describe 'whithout param cpf' do
    	render_views
    	it 'get index page' do
        expect(controller.gas_vouchers).to eq([])
        is_expected.to respond_with(:success)
        is_expected.to render_template(:index)
    	end
    end

    describe 'whith param cpf' do
      before { gas_voucher }
      before { get(:index, params: { cpf: '348.363.653-68' }, xhr: true ) }
      render_views

      it 'get index page with cpf param for filter' do
        expect(GasVoucher.count).to eq(1)
        expect(controller.gas_vouchers.first).to eq(gas_voucher)
        is_expected.to respond_with(:success)
        expect(response).to render_template('transparency/covid19/gas_vouchers/_index')
      end
    end
  end
end