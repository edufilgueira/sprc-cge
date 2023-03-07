require 'rails_helper'

describe Integration::CityUndertakings::CityUndertaking do

  subject(:city_undertaking) { build(:integration_city_undertakings_city_undertaking) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_city_undertakings_city_undertaking, :invalid)).to be_invalid }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:expense).with_values([:convenant, :contract]) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :municipio }
    it { is_expected.to validate_presence_of :mapp }
    it { is_expected.to validate_presence_of :sic }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:organ_id).of_type(:integer) }
      it { is_expected.to have_db_column(:creditor_id).of_type(:integer) }
      it { is_expected.to have_db_column(:undertaking_id).of_type(:integer) }

      it { is_expected.to have_db_column(:municipio).of_type(:string) }
      it { is_expected.to have_db_column(:tipo_despesa).of_type(:string) }
      it { is_expected.to have_db_column(:sic).of_type(:integer) }
      it { is_expected.to have_db_column(:mapp).of_type(:string) }
      it { is_expected.to have_db_column(:valor_programado1).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_programado2).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_programado3).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_programado4).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_programado5).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_programado6).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_programado7).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_programado8).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_executado1).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_executado2).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_executado3).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_executado4).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_executado5).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_executado6).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_executado7).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_executado8).of_type(:decimal) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

      describe 'indexes' do
        it { is_expected.to have_db_column(:organ_id).of_type(:integer) }
        it { is_expected.to have_db_column(:creditor_id).of_type(:integer) }
        it { is_expected.to have_db_column(:undertaking_id).of_type(:integer) }
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organ) }
    it { is_expected.to belong_to(:creditor) }
    it { is_expected.to belong_to(:undertaking) }
    it { is_expected.to belong_to(:contract) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:title).to(:organ).with_prefix }
    it { is_expected.to delegate_method(:title).to(:creditor).with_prefix }
    it { is_expected.to delegate_method(:title).to(:undertaking).with_prefix }
  end

  context 'sprc' do
    describe 'setup' do
      # Define que este model deve conectar na base de dados do sprc-data
      it { is_expected.to be_kind_of(ApplicationDataRecord) }

      it { expect(described_class.ancestors.include? Sortable).to be_truthy }
    end

    describe 'sortable' do
      describe 'default_sort_column' do
        let(:expected) { 'integration_contracts_contracts.data_assinatura' }
        it { expect(described_class.default_sort_column).to eq expected }
      end

      describe 'default_sort_direction' do
        it { expect(described_class.default_sort_direction).to eq :desc }
      end
    end

    describe 'helpers' do
      it { expect(city_undertaking.title).to eq(city_undertaking.undertaking_title) }
    end
  end
end
