require 'rails_helper'

describe PPA::Calculators::RegionalInitiativeBudgetCalculator do

  describe '::new' do
    it 'raises error for invalid quadrennium' do
      expect { described_class.new(quadrennium: 'invalid') }.to raise_error TypeError
    end

    it 'raises error for inexistent region' do
      expect { described_class.new(quadrennium: [2016, 2019], region: -1) }.to raise_error ActiveRecord::RecordNotFound
    end
  end


  describe '::calculate' do
    let!(:quadrennium) { [2016, 2019] }
    let(:bienniums) do [
      PPA::Biennium.new([quadrennium.first, quadrennium.first + 1]),
      PPA::Biennium.new([quadrennium.last - 1, quadrennium.last])
    ] end
    let!(:region) { create :ppa_region }

    let!(:calculator)   { described_class.new quadrennium: quadrennium, region: region }
    subject(:calculate) { calculator.calculate }


    let!(:initiative) { create :ppa_initiative }


    context 'when there are no initiatives in the given context' do
      it 'creates no budgets' do
        expect { calculate }.not_to change { PPA::RegionalInitiativeBudget.count }
      end
    end

    context 'when there are initiatives in the given context' do
      let!(:regional_initiative) do
        create :ppa_regional_initiative,
          region: region, initiative: initiative
      end

      let!(:biennial_regional_initiatives) do
        [
          create(:ppa_biennial_regional_initiative, biennium: bienniums.first, region: region, initiative: initiative),
          create(:ppa_biennial_regional_initiative, biennium: bienniums.last,  region: region, initiative: initiative)
        ]
      end

      context 'but there are no calculates biennial budgets for them' do
        it 'creates no budgets' do
          expect { calculate }.not_to change { PPA::RegionalInitiativeBudget.count }
        end
      end

      context 'and there calculated biennial budgets for them' do
        let!(:first_biennium_biennial_budgets) do
          create_list :ppa_biennial_regional_initiative_budget, 1,
            regional_initiative: biennial_regional_initiatives.first
        end

        let!(:second_biennium_biennial_budgets) do
          create_list :ppa_biennial_regional_initiative_budget, 1,
            regional_initiative: biennial_regional_initiatives.last
        end

        let!(:biennial_budgets) { first_biennium_biennial_budgets + second_biennium_biennial_budgets }


        # controla o recorte pela iniciativa
        let!(:other_initiative_second_biennium_biennial_budgets) do
          other_biennial_regional_initiative = create :ppa_biennial_regional_initiative,
            biennium: bienniums.last, region: region

          create_list :ppa_biennial_regional_initiative_budget, 1,
            regional_initiative: other_biennial_regional_initiative
        end

        # para garantir o recorte correto por biênio
        let!(:other_quadrennium_budgets) do
          other_quadrennium_biennial_regional_initiative =
            create :ppa_biennial_regional_initiative,
              biennium: PPA::Biennium.new([quadrennium.last + 1, quadrennium.last + 2]),
              region: region, initiative: initiative

          create_list :ppa_biennial_regional_initiative_budget, 1,
            regional_initiative: other_quadrennium_biennial_regional_initiative
        end


        it 'creates a budget for the quadrennial initiative' do
          expect { calculate }.to change { regional_initiative.budgets.count }.by(1)

          budget = regional_initiative.budgets.last

          expect(budget).to have_attributes expected: biennial_budgets.map(&:expected).sum,
                                            actual:   biennial_budgets.map(&:actual).sum
        end
      end

    end

  end

end
