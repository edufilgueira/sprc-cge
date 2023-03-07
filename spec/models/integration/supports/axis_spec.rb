require 'rails_helper'

describe Integration::Supports::Axis do
  subject(:axis) { build(:integration_supports_axis) }

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
end
