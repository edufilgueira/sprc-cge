require 'rails_helper'

describe PPA::SourceMappers::Biennial::RegionalInitiativeSourceMapper do

  describe '::map' do
    let!(:source) { create :ppa_source_guideline }
    let!(:mapper) { described_class.new source }
    subject(:map) { mapper.map }

    context 'blacklist' do
      it "ignores source with initiative code '-' (missing)" do
        source.update! codigo_ppa_iniciativa: '-'
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
      let!(:initiative) { create :ppa_initiative, code: source.codigo_ppa_iniciativa, strategies: [strategy] }


      context 'when the target biennial regional initiative do not exist' do

        it 'creates the related biennial regional initiative' do
          expect { map }.to change { initiative.biennial_regional_initiatives.count }.by(1)

          target = initiative.biennial_regional_initiatives.last

          expect(target).to have_attributes(
            biennium: source.biennium,
            # start_year: source.biennium.start_year,
            # end_year: source.biennium.end_year,
            region_id: region.id,
            name: source.descricao_ppa_iniciativa
          )
        end

      end # "when target does not exist"


      context 'when the target biennial regional initiative already exists' do
        let!(:target) do
          create :ppa_biennial_regional_initiative,
                 initiative: initiative,
                 biennium: source.biennium, # using virtual attr writer
                 region: region
        end

        it 'does not create any biennial regional initiatives' do
          expect { map }.not_to change { described_class.target_class.count }
        end

        it 'updates the biennial regional strategy name' do
          expect do
            map
            target.reload
          end.to change { target.name }.to(source.descricao_ppa_iniciativa)
        end

      end # "when target already exists"

    end

  end

end
