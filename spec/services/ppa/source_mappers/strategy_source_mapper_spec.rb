require 'rails_helper'

describe PPA::SourceMappers::StrategySourceMapper do

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

      it 'expects associated Objective to be persisted' do
        allow(PPA::Region).to receive(:find_by!) # stubbing
        expect(PPA::Objective).to receive(:find_by!).and_call_original
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


      context 'when the target Strategy does not exist' do
        it 'creates the target Strategy' do
          expect { map }.to change { PPA::Strategy.count }.by(1)

          target = PPA::Strategy.last
          expect(target.code).to eq source.codigo_ppa_estrategia
          expect(target.name).to eq source.descricao_estrategia
        end

        it 'associates Strategy and Objective' do
          expect { map }.to change { PPA::Strategy.count }.by(1)

          target = PPA::Strategy.last
          expect(target.objective).to eq objective
        end

        it 'invokes Annual::RegionalStrategySourceMapper' do
          expect(PPA::SourceMappers::Annual::RegionalStrategySourceMapper).to receive(:map)
            .with(source).and_call_original
          map
        end

        it 'invokes Biennial::RegionalStrategySourceMapper' do
          expect(PPA::SourceMappers::Biennial::RegionalStrategySourceMapper).to receive(:map)
            .with(source).and_call_original
          map
        end
      end


      context 'when the target Strategy already exists' do
        let!(:target) do
          create :ppa_strategy, code: source.codigo_ppa_estrategia
        end

        it 'updates the target PPA::Strategy' do
          expect do
            map
            target.reload
          end.to change { PPA::Strategy.count }.by(0) # não cria nenhum registro
            .and change { target.name }.to(source.descricao_estrategia)
        end

        context 'when the target Strategy is associated with another Objective' do
          it 'updates Strategy, assocating it witht the given Objective' do
            expect do
              map
              target.reload
            end.to change { PPA::Strategy.count }.by(0) # not change
              .and change { target.objective }.to(objective)
          end
        end


        it 'invokes Annual::RegionalStrategySourceMapper' do
          expect(PPA::SourceMappers::Annual::RegionalStrategySourceMapper).to receive(:map)
            .with(source).and_call_original
          map
        end

        it 'invokes Biennial::RegionalStrategySourceMapper' do
          expect(PPA::SourceMappers::Biennial::RegionalStrategySourceMapper).to receive(:map)
            .with(source).and_call_original
          map
        end

      end
    end
  end

end
