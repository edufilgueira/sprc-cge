require 'rails_helper'

describe PPA::SourceMappers::Annual::RegionalStrategySourceMapper do

  describe '::map' do
    let!(:source) { create :ppa_source_guideline }
    let!(:mapper) { described_class.new source }
    subject(:map) { mapper.map }

    context 'blacklist' do
      it "ignores source with strategy code '-' (missing)" do
        source.update! codigo_ppa_estrategia: '-'
        expect(mapper).to be_blacklisted
      end
    end

    context 'pre-requisites' do
      it 'expects associated Region to be persisted' do
        expect(PPA::Region).to receive(:find_by!).and_call_original
        expect { map }.to raise_error ActiveRecord::RecordNotFound
      end

      it 'expects associated Strategy to be persisted' do
        allow(PPA::Region).to receive(:find_by!) # stubbing to bypass
        expect(PPA::Strategy).to receive(:find_by!).and_call_original
        expect { map }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'with all pre-requisites satisfied' do
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


      context 'when the target annual regional strategies do not exist' do

        it 'creates the two related regional strategies (one for each biennium year)' do
          expect { map }.to change { strategy.annual_regional_strategies.count }.by(2)

          first_year_regional_strategy  = strategy.annual_regional_strategies
            .in_year_and_region(source.biennium.first_year, region)
            .last
          second_year_regional_strategy = strategy.annual_regional_strategies
            .in_year_and_region(source.biennium.last_year, region)
            .last

          expect(first_year_regional_strategy).to  have_attributes region_id: region.id
          expect(second_year_regional_strategy).to have_attributes region_id: region.id
        end

      end # "when target does not exist"


      context 'when the target annual regional strategies already exists' do
        let!(:first_year_regional_strategy) do
          create :ppa_annual_regional_strategy,
                 strategy: strategy,
                 year: source.biennium.first,
                 region: region
        end

        let!(:second_year_regional_strategy) do
          create :ppa_annual_regional_strategy,
                 strategy: strategy,
                 year: source.biennium.second,
                 region: region
        end

        it 'does not create any annual regional strategies' do
          expect { map }.not_to change { described_class.target_class.count }
        end

      end # "when target already exists"

    end

  end

end
