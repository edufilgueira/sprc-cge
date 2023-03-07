require 'rails_helper'

describe Integration::Eparcerias::TransferBankOrder do

  subject(:transfer_bank_order) { build(:integration_eparcerias_transfer_bank_order) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_eparcerias_transfer_bank_order, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:isn_sic).of_type(:integer) }
      it { is_expected.to have_db_column(:numero_ordem_bancaria).of_type(:string) }
      it { is_expected.to have_db_column(:tipo_ordem_bancaria).of_type(:string) }
      it { is_expected.to have_db_column(:nome_benceficiario).of_type(:string) }
      it { is_expected.to have_db_column(:valor_ordem_bancaria).of_type(:decimal).with_options(precision: 12, scale: 2) }
      it { is_expected.to have_db_column(:data_pagamento).of_type(:datetime) }
    end

    describe 'indexes' do
      # Os testes de db:indexes ficam concentrados na aplicação sprc-data
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:isn_sic) }
    it { is_expected.to validate_presence_of(:numero_ordem_bancaria) }
    it { is_expected.to validate_presence_of(:tipo_ordem_bancaria) }
    it { is_expected.to validate_presence_of(:nome_benceficiario) }
    it { is_expected.to validate_presence_of(:valor_ordem_bancaria) }
    it { is_expected.to validate_presence_of(:data_pagamento) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:convenant).with_foreign_key(:isn_sic).with_primary_key(:isn_sic) }
  end

  describe 'callbacks' do
    it 'notify_create' do
      transfer_bank_order = create(:integration_eparcerias_transfer_bank_order)

      expect(transfer_bank_order.utils_data_change.new_resource_notificable?).to be_truthy
      expect(transfer_bank_order.data_changes).to eq(nil)
    end
  end
end
