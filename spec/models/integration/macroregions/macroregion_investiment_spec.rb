require 'rails_helper'

describe Integration::Macroregions::MacroregionInvestiment do
  subject(:contract) { build(:integration_macroregions_macroregion_investiment) }

  describe 'factories' do
    # Tested @ SPRC-DATA
  end

  describe 'db' do
    # Tested @ SPRC-DATA
  end

  describe 'associations' do
    # Tested @ SPRC-DATA
  end

  describe 'validations' do
    # Tested @ SPRC-DATA
  end

  describe 'callbacks' do
    # Tested @ SPRC-DATA
  end

  describe 'setup' do
    # Define que este model deve conectar na base de dados do sprc-data
    it { is_expected.to be_kind_of(ApplicationDataRecord) }

    it { expect(described_class.ancestors.include?(Sortable)).to be_truthy }
  end
end
