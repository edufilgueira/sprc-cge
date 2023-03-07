require 'rails_helper'

describe Integration::RealStates::RealState do
  subject(:real_state) { build(:integration_real_states_real_state) }

  describe 'associations' do
    # Tested @ SPRC-DATA
  end

  describe 'validations' do
    # Tested @ SPRC-DATA
  end

  describe 'delegations' do
    # Tested @ SPRC-DATA
  end

  describe 'setup' do
    # Define que este model deve conectar na base de dados do sprc-data
    it { is_expected.to be_kind_of(ApplicationDataRecord) }

    it { expect(described_class.ancestors.include? Sortable).to be_truthy }
  end

  describe 'sortable' do
    describe 'default_sort_column' do
      let(:expected) { 'integration_real_states_real_states.id'}
      it { expect(described_class.default_sort_column).to eq expected }
    end

    describe 'default_sort_direction' do
      it { expect(described_class.default_sort_direction).to eq :asc }
    end
  end

  describe 'helpers' do
    it { expect(real_state.title).to eq(real_state.descricao_imovel) }
  end
end
