require 'rails_helper'

describe PPA::SourceMappers::Biennial::RegionalStrategySourceMapper do

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
        allow(PPA::Region).to receive(:find_by!) # stubbing
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
                               name: source.descricao_objetivo_estrategico,
                               themes: [theme] # associando ao tema
      end
      let!(:strategy) do
        create :ppa_strategy, code: source.codigo_ppa_estrategia,
                              name: source.descricao_estrategia,
                              objective: objective # associando ao objetivo
      end


      context 'when the target biennial regional strategy do not exist' do

        it 'creates the related biennial regional strategy' do
          expect { map }.to change { strategy.biennial_regional_strategies.count }.by(1)

          target = strategy.biennial_regional_strategies.last

          expect(target).to have_attributes(
            start_year: source.biennium.start_year,
            end_year: source.biennium.end_year,
            region_id: region.id
          )
        end

      end # "when target does not exist"


      context 'when the target biennial regional strategy already exists' do
        let!(:target) do
          create :ppa_biennial_regional_strategy,
                 strategy: strategy,
                 biennium: source.biennium, # using virtual attr writer
                 region: region
        end

        it 'updates the related biennial regional strategy' do
          expect do
            map
            target.reload
          end.to change { described_class.target_class.count }.by(0) # does not change
            # TODO ppa priority
            # .and change { target.priority }
            # .and change { target.priority_index }
        end

        context 'handling prioridade_regional' do
          context 'when "Sim"' do
            before do
              source.update! prioridade_regional: 'Sim'
              target.update! priority: nil  # garantindo que não esteja priorizada, para verificar mudança
            end

            it 'updates the related biennial regional strategy to be prioritized' do
              expect do
                map
                target.reload
              end.to change { target.prioritized? }.to true
            end
          end

          context 'when "Não"' do
            before do
              source.update! prioridade_regional: 'Não'
              target.update! priority: 'prioritized'  # garantindo que esteja priorizada, para verificar mudança
            end

            it 'updates the related biennial regional strategy to be non-prioritized' do
              expect do
                map
                target.reload
              end.to change { target.prioritized? }.to false
            end
          end

          context 'when ignorable values ["-", nil, ""]' do
            before { source.update! prioridade_regional: ['-', nil, ''].sample }

            it 'updates the related biennial regional strategy to be non-prioritized' do
              map
              target.reload

              expect(target).not_to be_prioritized
            end
          end
        end

        context 'handling ordem_prioridade' do
          context 'with a "present" value (number)"' do
            before do
              source.update! ordem_prioridade: ['1', 2].sample
              target.update! priority_index: 5  # garantindo um valor que gere mudança
            end

            it 'updates the related biennial regional strategy priority index to its value' do
              expect do
                map
                target.reload
              end.to change { target.priority_index }.to source.ordem_prioridade.to_i
            end
          end

          context 'with an ignorable values [0, "0", "-", nil, ""]' do
            before do
              source.update! ordem_prioridade: [0, '0', '-', nil, ''].sample
              target.update! priority_index: 5  # garantindo um valor que gere mudança
            end

            it 'updates the related biennial regional strategy priority index to nil' do
              expect do
                map
                target.reload
              end.to change { target.priority_index }.to nil
            end
          end
        end

      end


    end # with all pre-requisites

  end # ::map

end
