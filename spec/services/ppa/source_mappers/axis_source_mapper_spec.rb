require 'rails_helper'

describe PPA::SourceMappers::AxisSourceMapper do


  describe '::map' do
    let!(:source) { create :ppa_source_axis_theme }
    subject(:map) { described_class.map source }

    context 'when the target PPA::Axis does not exist' do
      it 'creates the target PPA::Axis' do
        expect { map }.to change { PPA::Axis.count }.by(1)

        target = PPA::Axis.last
        expect(target.code).to eq source.codigo_eixo
        expect(target.name).to eq source.descricao_eixo
      end
    end

    context 'when the target PPA::Axis already exists' do
      let!(:target) { create :ppa_axis, code: source.codigo_eixo }

      it 'updates the target PPA::Axis' do
        expect do
          map
          target.reload
        end.to change { PPA::Axis.count }.by(0) # não cria nenhum registro
          .and change { target.name }.to(source.descricao_eixo)
      end
    end
  end

  describe '::map_all' do
    let!(:sources) { create_list :ppa_source_axis_theme, 3 }
    subject(:map_all) { described_class.map_all }

    context 'when the target PPA::Axis-s do not exist' do
      it 'creates all target PPA::Axis' do
        expect { map_all }.to change { PPA::Axis.count }.by(sources.size)

        sources.each do |source|
          expect(PPA::Axis.find_by(code: source.codigo_eixo)).to be_present
        end
      end
    end

    context 'when some of the target PPA::Axis-s already exists' do
      let!(:existing_targets) do
        sources[0..1].map do |source|
          create :ppa_axis, code: source.codigo_eixo,
                            name: "existing #{source.descricao_eixo}" # para testar atualização de nome
        end
      end

      it 'creates the non-existing target PPA::Axis-s' do
        expect { map_all }.to change {PPA::Axis.count }
          .by(sources.size - existing_targets.size)
      end

      it 'updates the existing target PPA::Axis-s names' do
        expect do
          map_all
          existing_targets.each &:reload
        end.to change { existing_targets.map(&:name) }
      end
    end
  end

end
