require 'rails_helper'

describe Transparency::Contracts::TransferBankOrdersController do

  let(:contract) { create(:integration_contracts_convenant) }
  let(:transfer_bank_order) { create(:integration_eparcerias_transfer_bank_order, contract: contract, isn_sic: contract.isn_sic) }

  describe '#index' do
    it 'render partial' do
      get(:index, xhr: true, params: { id: contract })

      expect(controller).to render_template('shared/transparency/contracts/transfer_bank_orders/_index')
    end
  end

  describe '#download' do
    it 'render xlsx' do
      filename = "transfer_bank_order_#{contract.isn_sic}.xlsx"

      path = Rails.root.to_s + "/public/files/downloads/integration/contracts/convenants/transfer_bank_orders/#{filename}"

      expect(controller).to receive(:send_file).with(path, { filename: "#{filename}", type: 'application/xlsx' }) do
        controller.render body: nil # to prevent a 'missing template' error
      end

      get(:download, xhr: true, format: :xlsx, params: { id: contract })
    end

    it 'render csv' do
      filename = "transfer_bank_order_#{contract.isn_sic}.csv"

      path = Rails.root.to_s + "/public/files/downloads/integration/contracts/convenants/transfer_bank_orders/#{filename}"

      expect(controller).to receive(:send_file).with(path, { filename: "#{filename}", type: 'application/csv' }) do
        controller.render body: nil # to prevent a 'missing template' error
      end

      get(:download, xhr: true, format: :csv, params: { id: contract })
    end
  end
end
