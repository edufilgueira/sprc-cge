require 'rails_helper'

describe PPA::SourceMappers::InitiativeSourceMapper do

  describe '::map' do
    let!(:source) { create :ppa_source_guideline }
    let!(:mapper) { described_class.new source }
    subject(:map) { mapper.map }

    context 'blacklist' do
      it "ignores source with initiative code '-' (missing)" do
        source.update! codigo_ppa_iniciativa: '-'
        expect(mapper).to be_blacklisted
      end

      # PATCH enquanto aguardamos normalização dos dados servidor pelo webservice de
      # Integrations::PPA::Source::Guideline::Importer
      it "ignores source with strategy code '-' (missing)", :patch do
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
                               name: source.descricao_objetivo_estrategico,
                               themes: [theme] # associando ao tema
      end
      let!(:strategy) do
        create :ppa_strategy, code: source.codigo_ppa_estrategia,
                              name: source.descricao_estrategia,
                              objective: objective # associando ao objetivo
      end


      context 'when the target Initiative does not exist' do
        it 'creates the target Initiative' do
          expect { map }.to change { PPA::Initiative.count }.by(1)

          target = PPA::Initiative.last
          expect(target.code).to eq source.codigo_ppa_iniciativa
          expect(target.name).to eq source.descricao_ppa_iniciativa
        end

        it 'associates Initiative and Strategy' do
          expect { map }.to change { strategy.initiatives.count }.by(1)

          target = PPA::Initiative.last
          associated_strategy = strategy
          expect(target.strategy_ids).to include associated_strategy.id
        end

        context 'for annual associations' do
          it 'invokes Annual::RegionalInitiativeSourceMapper' do
            expect(PPA::SourceMappers::Annual::RegionalInitiativeSourceMapper).to receive(:map)
              .with(source).and_call_original
            map
          end
        end

        context 'for biennial associations' do
          it 'invokes Biennial::RegionalInitiativeSourceMapper' do
            expect(PPA::SourceMappers::Biennial::RegionalInitiativeSourceMapper).to receive(:map)
              .with(source).and_call_original
            map
          end
        end

        context 'for quadrennial associations' do
          it 'invokes RegionalInitiativeSourceMapper' do
            expect(PPA::SourceMappers::RegionalInitiativeSourceMapper).to receive(:map)
              .with(source).and_call_original
            map
          end
        end

      end # when initiative does not exist



      context 'when the target Initiative already exists' do
        let!(:target) do
          create :ppa_initiative, code: source.codigo_ppa_iniciativa,
                                  strategies: [strategy] # associando à estatégia
        end

        it 'updates the target PPA::Initiative' do
          expect do
            map
            target.reload
          end.to change { PPA::Initiative.count }.by(0) # não cria nenhum registro
            .and change { target.name }.to(source.descricao_ppa_iniciativa)
        end

        context 'when the target Initiative is associated to another Strategy' do
          # atualizando a associação para apenas uma nova estratégia
          before { target.strategies = [create(:ppa_strategy)] }

          it 'updates Initiative, assocating it with the given Strategy too' do
            expect do
              map
              target.reload
            end.to change { PPA::Initiative.count }.by(0) # not change
              .and change { strategy.initiatives.count }.by(1)

            expect(target.strategy_ids).to include strategy.id
          end
        end

        context 'for annual associations' do
          it 'invokes Annual::RegionalInitiativeSourceMapper' do
            expect(PPA::SourceMappers::Annual::RegionalInitiativeSourceMapper).to receive(:map)
              .with(source).and_call_original
            map
          end
        end

        context 'for biennial associations' do
          it 'invokes Biennial::RegionalInitiativeSourceMapper' do
            expect(PPA::SourceMappers::Biennial::RegionalInitiativeSourceMapper).to receive(:map)
              .with(source).and_call_original
            map
          end
        end

        context 'for quadrennial associations' do
          it 'invokes RegionalInitiativeSourceMapper' do
            expect(PPA::SourceMappers::RegionalInitiativeSourceMapper).to receive(:map)
              .with(source).and_call_original
            map
          end
        end

      end # when initiative already exists


    end
  end

end
