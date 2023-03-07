require 'rails_helper'

describe PPA::Calculators::Biennial::RegionalProductGoalCalculator do

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


    let!(:product) { create :ppa_product }


    context 'when there are no products in the given context' do
      it 'creates no goals' do
        expect { calculate }.not_to change { PPA::Biennial::RegionalProductGoal.count }
      end
    end

    context 'when there are products in the given context' do
      let!(:regional_product) do
        create :ppa_biennial_regional_product,
          biennium: biennium, region: region,
          product: product
      end

      let!(:annual_regional_products) do
        [
          create(:ppa_annual_regional_product, year: biennium.first_year,  region: region, product: product),
          create(:ppa_annual_regional_product, year: biennium.second_year, region: region, product: product)
        ]
      end

      context 'but there are no calculates annual goals for them' do
        it 'creates no goals' do
          expect { calculate }.not_to change { PPA::Biennial::RegionalProductGoal.count }
        end
      end

      context 'and there calculated annual goals for them' do
        let!(:first_year_annual_goals) do
          create_list :ppa_annual_regional_product_goal, 1,
            regional_product: annual_regional_products.first,
            period: :until_december
        end

        let!(:second_year_annual_goals) do
          create_list :ppa_annual_regional_product_goal, 1,
            regional_product: annual_regional_products.last,
            period: :until_march
        end

        let!(:annual_goals) { first_year_annual_goals + second_year_annual_goals }


        # controlando o recorte de "período mais recente" para cálculo de meta
        let!(:old_first_year_annual_goals) do
          create_list :ppa_annual_regional_product_goal, 1,
            regional_product: annual_regional_products.first,
            period: :until_march # é anterior a :until_december. Logo, deverá ser ignorado!
        end

        let!(:other_product_second_year_annual_goals) do
          other_annual_regional_product =
            create :ppa_annual_regional_product, year: biennium.first_year,
              region: region # other product! `, product: product`

          create_list :ppa_annual_regional_product_goal, 1,
            regional_product: other_annual_regional_product,
            period: :until_march
        end

        # para garantir o recorte correto por biênio
        let!(:other_biennium_goals) do
          other_biennium_year_annual_regional_product =
            create :ppa_annual_regional_product, year: biennium.second_year + 1,
              region: region, product: product

          create_list :ppa_annual_regional_product_goal, 1,
            regional_product: other_biennium_year_annual_regional_product,
            period: :until_march
        end


        it 'creates a goal for the biennial product' do
          expect { calculate }.to change { regional_product.goals.count }.by(1)

          goal = regional_product.goals.last

          expect(goal).to have_attributes expected: annual_goals.map(&:expected).sum,
                                          actual:   annual_goals.map(&:actual).sum
        end
      end

    end

  end

end
