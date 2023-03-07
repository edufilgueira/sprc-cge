require 'rails_helper'

RSpec.describe PPA::Calculator do
  subject(:calculator) { described_class }

  describe '::calculate_all' do
    subject(:calculate_all) { calculator.calculate_all }

    it 'orchestrates calculators processing' do
      # initiative calculators
      expect(PPA::Calculators::Annual::RegionalInitiativeBudgetCalculator).to receive(:calculate_all)
      expect(PPA::Calculators::Biennial::RegionalInitiativeBudgetCalculator).to receive(:calculate_all)
      expect(PPA::Calculators::RegionalInitiativeBudgetCalculator).to receive(:calculate_all)

      # product calculators
      expect(PPA::Calculators::Biennial::RegionalProductGoalCalculator).to receive(:calculate_all)
      expect(PPA::Calculators::RegionalProductGoalCalculator).to receive(:calculate_all)


      # internal couter caches calculation method
      expect(calculator).to receive(:calculate_counts)

      calculate_all
    end
  end

end
