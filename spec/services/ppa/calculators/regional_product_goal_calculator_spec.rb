require 'rails_helper'

describe PPA::Calculators::RegionalProductGoalCalculator do

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


    let!(:product) { create :ppa_product }


    context 'when there are no products in the given context' do
      it 'creates no goals' do
        expect { calculate }.not_to change { PPA::RegionalProductGoal.count }
      end
    end

    context 'when there are products in the given context' do
      let!(:regional_product) do
        create :ppa_regional_product,
          region: region, product: product
      end

      let!(:biennial_regional_products) do
        [
          create(:ppa_biennial_regional_product, biennium: bienniums.first, region: region, product: product),
          create(:ppa_biennial_regional_product, biennium: bienniums.last,  region: region, product: product)
        ]
      end

      context 'but there are no calculates biennial goals for them' do
        it 'creates no goals' do
          expect { calculate }.not_to change { PPA::RegionalProductGoal.count }
        end
      end

      context 'and there calculated biennial goals for them' do
        let!(:first_biennium_biennial_goals) do
          create_list :ppa_biennial_regional_product_goal, 1,
            regional_product: biennial_regional_products.first
        end

        let!(:second_biennium_biennial_goals) do
          create_list :ppa_biennial_regional_product_goal, 1,
            regional_product: biennial_regional_products.last
        end

        let!(:biennial_goals) { first_biennium_biennial_goals + second_biennium_biennial_goals }


        # controla o recorte pela iniciativa
        let!(:other_product_second_biennium_biennial_goals) do
          other_biennial_regional_product = create :ppa_biennial_regional_product,
            biennium: bienniums.last, region: region

          create_list :ppa_biennial_regional_product_goal, 1,
            regional_product: other_biennial_regional_product
        end

        # para garantir o recorte correto por biênio
        let!(:other_quadrennium_goals) do
          other_quadrennium_biennial_regional_product =
            create :ppa_biennial_regional_product,
              biennium: PPA::Biennium.new([quadrennium.last + 1, quadrennium.last + 2]),
              region: region, product: product

          create_list :ppa_biennial_regional_product_goal, 1,
            regional_product: other_quadrennium_biennial_regional_product
        end


        it 'creates a goal for the quadrennial product' do
          expect { calculate }.to change { regional_product.goals.count }.by(1)

          goal = regional_product.goals.last

          expect(goal).to have_attributes expected: biennial_goals.map(&:expected).sum,
                                          actual:   biennial_goals.map(&:actual).sum
        end
      end

    end

  end

end
