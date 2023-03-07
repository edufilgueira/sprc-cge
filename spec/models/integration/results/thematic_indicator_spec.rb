require 'rails_helper'

describe Integration::Results::ThematicIndicator do
  subject(:thematic_indicator) { build(:integration_results_thematic_indicator) }

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

  describe 'helpers' do
    it 'title' do
      expect(thematic_indicator.title).to eq(thematic_indicator.indicador)
    end

    it 'valores_realizados_by_year' do
      result = thematic_indicator.valores_realizados_by_year('2014')

      expect(result[:value]).to eq('622.19')
      expect(result[:status]).to eq(:done)
    end

    it 'valores_programados_by_year' do
      result = thematic_indicator.valores_programados_by_year('2016')

      expect(result[:value]).to eq('547.50')
      expect(result[:status]).to eq(:scheduled)
    end
  end
end
