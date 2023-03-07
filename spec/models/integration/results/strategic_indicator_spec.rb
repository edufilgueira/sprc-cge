require 'rails_helper'

describe Integration::Results::StrategicIndicator do

  subject(:strategic_indicator) { build(:integration_results_strategic_indicator) }

  describe 'associations' do
    # Tested @ SPRC-DATA
  end

  describe 'validations' do
    # Tested @ SPRC-DATA
  end

  describe 'delegations' do
    # Tested @ SPRC-DATA
  end

  describe 'scopes' do
    it 'only poder executivo' do
      organ = create(:integration_supports_organ, poder: 'LEGISLATIVO', orgao_sfp: false)
      create(:integration_results_strategic_indicator, organ: organ)
      create(:integration_results_strategic_indicator)

      expect(Integration::Results::StrategicIndicator.count).to eq(1)
    end
  end

  describe 'setup' do
    # Define que este model deve conectar na base de dados do sprc-data
    it { is_expected.to be_kind_of(ApplicationDataRecord) }

    it { expect(described_class.ancestors.include? Sortable).to be_truthy }
  end

  describe 'helpers' do
    it 'title' do
      expect(strategic_indicator.title).to eq(strategic_indicator.indicador)
    end

    it 'valores_realizados_by_year' do
      expect(strategic_indicator.valores_realizados_by_year('2014')).to eq('24.10')
    end

    it 'valores_atuais_by_year' do
      expect(strategic_indicator.valores_atuais_by_year('2016')).to be_nil
    end
  end
end
