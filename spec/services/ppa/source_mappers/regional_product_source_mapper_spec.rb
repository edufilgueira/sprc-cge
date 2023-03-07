require 'rails_helper'

describe PPA::SourceMappers::RegionalProductSourceMapper do

  describe '::map' do
    let!(:source) { create :ppa_source_guideline }
    let!(:mapper) { described_class.new source }
    subject(:map) { mapper.map }

    context 'blacklist' do
      it "ignores source with product code '-' (missing)" do
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


      context 'when the target regional product do not exist' do

        it 'creates the one regional product' do
          expect { map }.to change { described_class.target_class.count }.by(1)

          target = product.regional_products.last

          expect(target).to have_attributes region_id: region.id
        end

      end # "when target does not exist"


      context 'when the target regional product already exists' do
        let!(:target) do
          create :ppa_regional_product,
                 product: product,
                 region: region
        end

        it 'does not create any regional product' do
          expect { map }.not_to change { described_class.target_class.count }
        end

      end # "when target already exists"

    end

  end

end
