require 'rails_helper'

describe PPA::SourceMappers::ProductSourceMapper do

  describe '::map' do
    let!(:source) { create :ppa_source_guideline }
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

      it 'expects associated Initiative to be persisted' do
        allow(PPA::Region).to receive(:find_by!) # stubbing to bypass
        expect(PPA::Initiative).to receive(:find_by!).and_call_original
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
      let!(:initiative) do
        create :ppa_initiative, code: source.codigo_ppa_iniciativa,
                                strategies: [strategy] # associando à estatégia
      end


      context 'when the target Product does not exist' do
        it 'creates the target Product' do
          expect { map }.to change { PPA::Product.count }.by(1)

          target = PPA::Product.last
          expect(target.code).to eq source.codigo_produto
          expect(target.name).to eq source.descricao_produto
        end

        it 'associates Product and Initiative' do
          expect { map }.to change { initiative.products.count }.by(1)

          target = PPA::Product.last
          associated_initiative = initiative
          expect(target.initiative).to eq associated_initiative
        end


        context 'for annual associations' do
          it 'invokes Annual::RegionalProductSourceMapper' do
            expect(PPA::SourceMappers::Annual::RegionalProductSourceMapper).to receive(:map)
              .with(source).and_call_original
            map
          end

          it 'invokes Annual::RegionalProductGoalSourceMapper' do
            expect(PPA::SourceMappers::Annual::RegionalProductGoalSourceMapper).to receive(:map)
              .with(source).and_call_original
            map
          end
        end


        context 'for biennial associations' do
          it 'invokes Biennial::RegionalProductSourceMapper' do
            expect(PPA::SourceMappers::Biennial::RegionalProductSourceMapper).to receive(:map)
              .with(source).and_call_original
            map
          end
        end


        context 'for quadrennial associations' do
          it 'invokes RegionalProductSourceMapper' do
            expect(PPA::SourceMappers::RegionalProductSourceMapper).to receive(:map)
              .with(source).and_call_original
            map
          end
        end

      end # end 'when product does not exist'


      context 'when the target Product already exists' do
        let!(:target) do
          create :ppa_product, code: source.codigo_produto,
                               initiative: initiative # associando à iniciativa
        end

        it 'updates the target Product' do
          expect do
            map
            target.reload
          end.to change { PPA::Product.count }.by(0) # não cria nenhum registro
            .and change { target.name }.to(source.descricao_produto)
        end

        context 'when the target Product is associated to another Initiative' do
          # atualizando a associação uma outra iniciativa
          before { target.update! initiative_id: create(:ppa_initiative, strategies: [strategy]).id }

          it 'updates Product, assocating it with the given Initiative too' do
            expect do
              map
              target.reload
            end.to change { PPA::Initiative.count }.by(0) # not change
              .and change { initiative.products.count }.by(1)

            expect(target.initiative).to eq initiative
          end
        end


        context 'for annual associations' do
          it 'invokes Annual::RegionalProductSourceMapper' do
            # tests moved to Annual::RegionalProductSourceMapper
            expect(PPA::SourceMappers::Annual::RegionalProductSourceMapper).to receive(:map)
              .with(source).and_call_original
            map
          end

          it 'invokes Annual::RegionalProductGoalSourceMapper' do
            # tests moved to Annual::RegionalProductGoalSourceMapper
            expect(PPA::SourceMappers::Annual::RegionalProductGoalSourceMapper).to receive(:map)
              .with(source).and_call_original
            map
          end
        end

        context 'for biennial associations' do
          it 'invokes Biennial::RegionalProductSourceMapper' do
            expect(PPA::SourceMappers::Biennial::RegionalProductSourceMapper).to receive(:map)
              .with(source).and_call_original
            map
          end
        end

        context 'for quadrennial associations' do
          it 'invokes RegionalProductSourceMapper' do
            expect(PPA::SourceMappers::RegionalProductSourceMapper).to receive(:map)
              .with(source).and_call_original
            map
          end
        end


      end # when target product already exists

    end

  end

end
