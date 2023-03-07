require 'rails_helper'

describe PPA::Calculators::Biennial::RegionalInitiativeBudgetCalculator do

  describe '::new' do
    it 'raises error for invalid biennium' do
      expect { described_class.new(biennium: 'invalid') }.to raise_error ArgumentError
    end

    it 'raises error for inexistent region' do
      expect { described_class.new(biennium: '2016-2017', region: -1) }.to raise_error ActiveRecord::RecordNotFound
    end
  end


  describe '::calculate' do
    let!(:biennium) { PPA::Biennium.new '2016-2017' }
    let!(:region)   { create :ppa_region }

    let!(:calculator)   { described_class.new biennium: biennium, region: region }
    subject(:calculate) { calculator.calculate }


    let!(:initiative) { create :ppa_initiative }


    context 'when there are no initiatives in the given context' do
      it 'creates no budgets' do
        expect { calculate }.not_to change { PPA::Biennial::RegionalInitiativeBudget.count }
      end
    end

    context 'when there are initiatives in the given context' do
      let!(:regional_initiative) do
        create :ppa_biennial_regional_initiative,
          biennium: biennium, region: region,
          initiative: initiative
      end

      let!(:annual_regional_initiatives) do
        [
          create(:ppa_annual_regional_initiative, year: biennium.first_year,  region: region, initiative: initiative),
          create(:ppa_annual_regional_initiative, year: biennium.second_year, region: region, initiative: initiative)
        ]
      end

      context 'but there are no calculates annual budgets for them' do
        it 'creates no budgets' do
          expect { calculate }.not_to change { PPA::Biennial::RegionalInitiativeBudget.count }
        end
      end

      context 'and there calculated annual budgets for them' do
        let!(:first_year_annual_budgets) do
          create_list :ppa_annual_regional_initiative_budget, 1,
            regional_initiative: annual_regional_initiatives.first,
            period: :until_december
        end

        let!(:second_year_annual_budgets) do
          create_list :ppa_annual_regional_initiative_budget, 1,
            regional_initiative: annual_regional_initiatives.last,
            period: :until_march
        end

        let!(:annual_budgets) { first_year_annual_budgets + second_year_annual_budgets }


        # controlando o recorte de "período mais recente" para cálculo de orçamento
        let!(:old_first_year_annual_budgets) do
          create_list :ppa_annual_regional_initiative_budget, 1,
            regional_initiative: annual_regional_initiatives.first,
            period: :until_march # é anterior a :until_december. Logo, deverá ser ignorado!
        end

        let!(:other_initiative_second_year_annual_budgets) do
          other_annual_regional_initiative =
            create :ppa_annual_regional_initiative, year: biennium.first_year,
              region: region # other initiative! `, initiative: initiative`

          create_list :ppa_annual_regional_initiative_budget, 1,
            regional_initiative: other_annual_regional_initiative,
            period: :until_march
        end

        # para garantir o recorte correto por biênio
        let!(:other_biennium_budgets) do
          other_biennium_year_annual_regional_initiative =
            create :ppa_annual_regional_initiative, year: biennium.second_year + 1,
              region: region, initiative: initiative

          create_list :ppa_annual_regional_initiative_budget, 1,
            regional_initiative: other_biennium_year_annual_regional_initiative,
            period: :until_march
        end


        it 'creates a budget for the biennial initiative' do
          expect { calculate }.to change { regional_initiative.budgets.count }.by(1)

          budget = regional_initiative.budgets.last

          expect(budget).to have_attributes expected: annual_budgets.map(&:expected).sum,
                                            actual:   annual_budgets.map(&:actual).sum
        end
      end

    end

  end

end
