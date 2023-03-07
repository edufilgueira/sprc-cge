require 'rails_helper'

describe PPA::SourceMappers::RegionSourceMapper do


  describe '::map' do
    let!(:source) { create :ppa_source_region }
    subject(:map) { described_class.map source }

    context 'blacklist' do
      it "ignores source with region code '15' ('ESTADO DO CEARÁ')" do
        source.update! codigo_regiao: '15'
        mapper = described_class.new source
        expect(mapper).to be_blacklisted
      end
    end

    context 'when the target PPA::Region does not exist' do
      it 'creates the target PPA::Region' do
        expect { map }.to change { PPA::Region.count }.by(1)

        created_region = PPA::Region.last
        expect(created_region.code).to eq source.codigo_regiao
        expect(created_region.name).to eq source.descricao_regiao
      end
    end

    context 'when the target PPA::Region already exists' do
      let!(:target) { create :ppa_region, code: source.codigo_regiao }

      it 'updates the target PPA::Region' do
        expect do
          map
          target.reload
        end.to change { PPA::Region.count }.by(0) # não cria nenhum registro
          .and change { target.name }.to(source.descricao_regiao)
      end
    end
  end

  describe '::map_all' do
    let!(:sources) { create_list :ppa_source_region, 3 }
    subject(:map_all) { described_class.map_all }

    context 'when the target PPA::Regions do not exist' do
      it 'creates all target PPA::Region' do
        expect { map_all }.to change { PPA::Region.count }.by(sources.size)

        sources.each do |source|
          expect(PPA::Region.find_by(code: source.codigo_regiao)).to be_present
        end
      end
    end

    context 'when some of the target PPA::Regions already exists' do
      let!(:existing_targets) do
        sources[0..1].map do |source|
          create :ppa_region, code: source.codigo_regiao,
                              name: "existing #{source.descricao_regiao}" # para testar atualização de nome
        end
      end

      it 'creates the non-existing target PPA::Regions' do
        expect { map_all }.to change {PPA::Region.count }
          .by(sources.size - existing_targets.size)
      end

      it 'updates the existing target PPA::Regions names' do
        expect do
          map_all
          existing_targets.each &:reload
        end.to change { existing_targets.map(&:name) }
      end
    end
  end

end
