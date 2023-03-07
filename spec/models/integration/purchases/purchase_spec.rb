require 'rails_helper'

describe Integration::Purchases::Purchase do
  subject(:purchase) { build(:integration_purchases_purchase) }

  describe 'associations' do
    # Tested @ SPRC-DATA
  end

  describe 'validations' do
    # Tested @ SPRC-DATA
  end

  describe 'setup' do
    # Define que este model deve conectar na base de dados do sprc-data
    it { is_expected.to be_kind_of(ApplicationDataRecord) }

    it { expect(described_class.ancestors.include? Sortable).to be_truthy }
  end

  describe 'sortable' do
    describe 'default_sort_column' do
      let(:expected) { 'integration_purchases_purchases.numero_publicacao'}
      it { expect(described_class.default_sort_column).to eq expected }
    end

    describe 'default_sort_direction' do
      it { expect(described_class.default_sort_direction).to eq :desc }
    end
  end

  describe 'helpers' do
    it { expect(purchase.title).to eq(purchase.descricao_item) }
  end

  describe 'active_on_month' do
    # Tested @ SPRC-DATA
  end

  describe 'scopes' do
    describe 'data_publicacao_in_range' do
      let!(:purchase_in_range) do
        create(:integration_purchases_purchase, data_publicacao: Date.today)
      end

      let!(:old_purchase) do
        create(:integration_purchases_purchase, data_publicacao: (Date.today-2.day))
      end

      let!(:new_purchase) do
        create(:integration_purchases_purchase, data_publicacao: (Date.today+2.day))
      end

      it do
        expect(described_class.data_publicacao_in_range(Date.yesterday, Date.tomorrow))
        .to eq [purchase_in_range]
      end
    end

    describe 'data_finalizada_in_range' do
      let!(:purchase_in_range) do
        create(:integration_purchases_purchase, data_finalizada: Date.today)
      end

      let!(:old_purchase) do
        create(:integration_purchases_purchase, data_finalizada: (Date.today-2.day))
      end

      let!(:new_purchase) do
        create(:integration_purchases_purchase, data_finalizada: (Date.today+2.day))
      end

      it do
        expect(described_class.data_finalizada_in_range(Date.yesterday, Date.tomorrow))
        .to eq [purchase_in_range]
      end
    end
  end

  describe 'callbacks' do
    it 'set_valor_total_calculated' do
      purchase = build(:integration_purchases_purchase)
      purchase.save

      expected = purchase.quantidade_estimada.to_f * purchase.valor_unitario.to_f

      expect(purchase.reload.valor_total_calculated).to eq(expected)
    end
  end
end
