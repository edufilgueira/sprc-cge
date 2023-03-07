require 'rails_helper'

describe PPA::SourceMappers::Annual::RegionalProductGoalSourceMapper do

  describe '::map' do
    let(:source_guideline_year) { 2017 } # permitindo alterar esse dado depois, para refletir em lógicas de negócio
    let!(:source) { create :ppa_source_guideline, ano: source_guideline_year }
    let!(:mapper) { described_class.new source }
    subject(:map) { mapper.map }

    context 'blacklist' do
      it "ignores source with initiative code '-' (missing)" do
        source.update! codigo_produto: '-'
        expect(mapper).to be_blacklisted
      end
    end

    context 'pre-requisites' do
      it 'expects associated Region to be persisted' do
        expect(PPA::Region).to receive(:find_by!).and_call_original
        expect { map }.to raise_error ActiveRecord::RecordNotFound
      end

      it 'expects associated Product to be persisted' do
        allow(PPA::Region).to receive(:find_by!) # stubbing to bypass
        expect(PPA::Product).to receive(:find_by!).and_call_original
        expect { map }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'with all pre-requisites satisfied' do
      let!(:region) { create :ppa_region, code: source.codigo_regiao }
      let!(:axis) { create :ppa_axis, code: source.codigo_eixo, name: source.descricao_eixo }
      let!(:theme) { create :ppa_theme, code: source.codigo_tema, name: source.descricao_tema, axis: axis }
      let!(:objective) do
        create :ppa_objective, code: source.codigo_ppa_objetivo_estrategico,
                               name: source.descricao_objetivo_estrategico,
                               themes: [theme] # associando ao tema
      end
      let!(:strategy) do
        create :ppa_strategy, code: source.codigo_ppa_estrategia,
                              name: source.descricao_estrategia,
                              objective: objective # associando ao objetivo
      end
      let!(:initiative) { create :ppa_initiative, code: source.codigo_ppa_iniciativa, strategies: [strategy] }
      let!(:product) { create :ppa_product, code: source.codigo_produto, initiative: initiative }

      # and annual regional products too!
      # --
      let!(:first_year_regional_product) do
        create :ppa_annual_regional_product,
               product: product,
               year: source.biennium.first,
               region: region
      end
      let!(:second_year_regional_product) do
        create :ppa_annual_regional_product,
               product: product,
               year: source.biennium.second,
               region: region
      end


      context 'when the target annual regional product goals do not exist' do

        context 'and there are no values for the goals (blank or both zero)' do
          before do
            rand_blank_value = -> { [0, nil, '', '-'].sample }
            source.update! descricao_referencia:    'Jan-Jun',
                           valor_programado1619_ar: rand_blank_value.call,
                           valor_programado1619_dr: rand_blank_value.call,
                           valor_programado_ano1:   rand_blank_value.call,
                           valor_programado_ano2:   rand_blank_value.call,
                           valor_programado_ano3:   rand_blank_value.call,
                           valor_programado_ano4:   rand_blank_value.call,
                           valor_realizado1619_ar:  rand_blank_value.call,
                           valor_realizado1619_dr:  rand_blank_value.call,
                           valor_realizado_ano1:    rand_blank_value.call,
                           valor_realizado_ano2:    rand_blank_value.call,
                           valor_realizado_ano3:    rand_blank_value.call,
                           valor_realizado_ano4:    rand_blank_value.call
          end

          it  'does not create any goal' do
            expect { map }.not_to change { PPA::Annual::RegionalProductGoal.count }
          end
        end # when there are no values for the goals

        context 'and there are values for the goals' do
          before do
            source.update! descricao_referencia:    'Jan-Jun',
                           valor_programado1619_ar: rand(1_000_000.11),
                           valor_programado1619_dr: rand(1_000_000.11),
                           valor_programado_ano1:   rand(1_000_000.11),
                           valor_programado_ano2:   rand(1_000_000.11),
                           valor_programado_ano3:   rand(1_000_000.11),
                           valor_programado_ano4:   rand(1_000_000.11),
                           valor_realizado1619_ar:  rand(1_000_000.11),
                           valor_realizado1619_dr:  rand(1_000_000.11),
                           valor_realizado_ano1:    rand(1_000_000.11),
                           valor_realizado_ano2:    rand(1_000_000.11),
                           valor_realizado_ano3:    rand(1_000_000.11),
                           valor_realizado_ano4:    rand(1_000_000.11)
          end

          context 'and source guideline year is 2017' do
            let(:source_guideline_year) { 2017 }

            it 'creates the two related regional product goals (one for each biennium year)' do
              expect { map }.to change { PPA::Annual::RegionalProductGoal.count }.by(2)

              first_year_regional_goal  = first_year_regional_product.goals.last
              second_year_regional_goal = second_year_regional_product.goals.last

              # XXX Para o ano de 2017, a importação usa ano1 e ano2, uma vez que é o recorte
              # do primeiro biênio do PPA! (2016, 2017)
              # - para ano 2018 na guideline, usa ano3 e ano 4 - segundo biênio do PPA (2018, 2019)!

              expect(first_year_regional_goal).to  have_attributes(
                period:   'until_june',
                expected: source.valor_programado_ano1,
                actual:   source.valor_realizado_ano1
              )

              expect(second_year_regional_goal).to have_attributes(
                period:   'until_june',
                expected: source.valor_programado_ano2,
                actual:   source.valor_realizado_ano2
              )
            end
          end # year 2017


          context 'and source guideline year is 2018' do
            let(:source_guideline_year) { 2018 }

            it 'creates the two related regional product goals (one for each biennium year)' do
              expect { map }.to change { PPA::Annual::RegionalProductGoal.count }.by(2)

              first_year_regional_goal  = first_year_regional_product.goals.last
              second_year_regional_goal = second_year_regional_product.goals.last

              # XXX Para o ano de 2018, a importação usa ano3 e ano4, uma vez que é o recorte
              # do segundo biênio do PPA! (2018, 2019)
              # - para ano 2017 na guideline, usa ano1 e ano 2 - primeiro biênio do PPA (2016, 2017)!

              expect(first_year_regional_goal).to  have_attributes(
                period:   'until_june',
                expected: source.valor_programado_ano3,
                actual:   source.valor_realizado_ano3
              )

              expect(second_year_regional_goal).to have_attributes(
                period:   'until_june',
                expected: source.valor_programado_ano4,
                actual:   source.valor_realizado_ano4
              )
            end
          end # year 2017

        end # when there are values for the goals

      end # "when target does not exist"



      context 'when the target annual regional product goals already exists' do
        let!(:first_year_regional_goal) do
          create :ppa_annual_regional_product_goal,
            regional_product: first_year_regional_product,
            period: 'until_june'
        end

        let!(:second_year_regional_goal) do
          create :ppa_annual_regional_product_goal,
            regional_product: second_year_regional_product,
            period: 'until_june'
        end

        context 'and there are values for the goals' do
          before do
            rand_value = -> { rand(1_000_000.11) }
            source.update! descricao_referencia:    'Jan-Jun',
                           valor_programado1619_ar: rand_value.call,
                           valor_programado1619_dr: rand_value.call,
                           valor_programado_ano1:   rand_value.call,
                           valor_programado_ano2:   rand_value.call,
                           valor_programado_ano3:   rand_value.call,
                           valor_programado_ano4:   rand_value.call,
                           valor_realizado1619_ar:  rand_value.call,
                           valor_realizado1619_dr:  rand_value.call,
                           valor_realizado_ano1:    rand_value.call,
                           valor_realizado_ano2:    rand_value.call,
                           valor_realizado_ano3:    rand_value.call,
                           valor_realizado_ano4:    rand_value.call
          end

          it 'does not create any annual regional products' do
            # expect { map }.not_to change { product.annual_regional_products.count }
            expect { map }.not_to change { described_class.target_class.count }
          end

          it 'updates their values' do
            expect do
              map
              first_year_regional_goal.reload
              second_year_regional_goal.reload
            end.to change { first_year_regional_goal.expected }.to(source.valor_programado_ano1)
              .and change { first_year_regional_goal.actual }.to(source.valor_realizado_ano1)
              .and change { second_year_regional_goal.expected }.to(source.valor_programado_ano2)
              .and change { second_year_regional_goal.actual }.to(source.valor_realizado_ano2)
          end


          context 'when the existing goals are in a different period' do
            before do # changing periods
              first_year_regional_goal.until_december!
              second_year_regional_goal.until_march!
            end

            it 'ignores them, creating new ones' do
              expect { map }.to change { described_class.target_class.count }.by(2)
            end
          end
        end

      end # "when target already exists"

    end

  end

end
