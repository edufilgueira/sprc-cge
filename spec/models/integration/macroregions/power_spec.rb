require 'rails_helper'

describe Integration::Macroregions::Power do
  subject(:power) { build(:integration_macroregions_power) }

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

  describe 'setup' do
    # Define que este model deve conectar na base de dados do sprc-data
    it { is_expected.to be_kind_of(ApplicationDataRecord) }
  end
end
