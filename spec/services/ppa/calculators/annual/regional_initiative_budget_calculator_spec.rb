require 'rails_helper'

describe PPA::Calculators::Annual::RegionalInitiativeBudgetCalculator do

  describe '::new' do
    it 'raises error for invalid period' do
      expect { described_class.new(period: 'invalid') }.to raise_error ArgumentError
    end
  end


  describe '::calculate' do
    let!(:year)   { 2017 } # XXX isso é custom! não alterar! tem relação de lógica de biênio do webservice!
    let!(:region) { create :ppa_region }
    let!(:period) { PPA::Annual::Measurement.periods.keys.sample }

    let!(:calculator)   { described_class.new year: year, region: region, period: period }
    subject(:calculate) { calculator.calculate }


    let!(:source) do # source para contexto de dados - é build => não persistido!
      build :ppa_source_guideline,
        ano: year,
        descricao_referencia: PPA::Annual::Measurement.descricao_referencia_for_period(period)
    end
    let!(:source_context) do
      source.attributes.slice(*%w[
        ano
        codigo_regiao
        codigo_eixo
        codigo_tema
        codigo_ppa_objetivo_estrategico
        codigo_ppa_iniciativa
        descricao_referencia
      ]).symbolize_keys # para usar em factories
    end
    let!(:region) { create :ppa_region, code: source.codigo_regiao }
    let!(:axis) { create :ppa_axis, code: source.codigo_eixo, name: source.descricao_eixo }
    let!(:theme) { create :ppa_theme, code: source.codigo_tema, name: source.descricao_tema, axis: axis }
    let!(:objective) do
      create :ppa_objective, code: source.codigo_ppa_objetivo_estrategico,
                             name: source.descricao_objetivo_estrategico
                             #themes: [theme] # associando ao tema
    end
    let!(:strategy) do
      create :ppa_strategy, code: source.codigo_ppa_estrategia,
                            name: source.descricao_estrategia,
                            objective: objective # associando ao objetivo
    end
    let!(:initiative) { create :ppa_initiative, code: source.codigo_ppa_iniciativa, strategies: [strategy] }

    context 'when there are no source guidelines for the given context' do
      it 'creates no budgets' do
        expect { calculate }.not_to change { PPA::Annual::RegionalInitiativeBudget.count }
      end
    end

    context 'when there are source guidelines for the given context' do
      let!(:guidelines) do
        rand_value = -> { rand(10_000_000.11) }
        create_list :ppa_source_guideline, 2,
          valor_lei_ano1:            rand_value.call,
          valor_lei_ano2:            rand_value.call,
          valor_lei_ano3:            rand_value.call,
          valor_lei_ano4:            rand_value.call,
          valor_lei_creditos_ano1:   rand_value.call,
          valor_lei_creditos_ano2:   rand_value.call,
          valor_lei_creditos_ano3:   rand_value.call,
          valor_lei_creditos_ano4:   rand_value.call,
          valor_empenhado_ano1:      rand_value.call,
          valor_empenhado_ano2:      rand_value.call,
          valor_empenhado_ano3:      rand_value.call,
          valor_empenhado_ano4:      rand_value.call,
          valor_pago_ano1:           rand_value.call,
          valor_pago_ano2:           rand_value.call,
          valor_pago_ano3:           rand_value.call,
          valor_pago_ano4:           rand_value.call,
          **source_context
      end

      context 'but there are no annual regional initiatives for the given context' do
        it 'creates no budgets' do
          expect { calculate }.not_to change { PPA::Annual::RegionalInitiativeBudget.count }
        end
      end

      context 'and there are annual regional initiatives for the given context' do
        let!(:regional_initiatives) do
          create_list :ppa_annual_regional_initiative, 1,
            year:       year,
            region:     region,
            initiative: initiative
        end

        it 'creates a budget for the annual initiative' do
          expect { calculate }.to change { PPA::Annual::RegionalInitiativeBudget.count }.by(1)

          budget = PPA::Annual::RegionalInitiativeBudget.last

          # XXX isso tem relação direta com o ano da importação! (2017)
          expect(budget).to have_attributes expected: guidelines.map(&:valor_lei_creditos_ano2).sum,
                                            actual:   guidelines.map(&:valor_empenhado_ano2).sum,
                                            period:   period
        end
      end

    end

  end

end
