require 'rails_helper'

describe PPA::SourceMappers::ThemeSourceMapper do

  describe '::map' do
    let!(:source) { create :ppa_source_axis_theme }
    subject(:map) { described_class.map source }

    context 'pre-requisites' do
      context 'when the related PPA::Axis does not exist' do
        it 'raises error' do
          expect { map }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'with all pre-requisites satisfied' do
      let!(:axis) { PPA::SourceMappers::AxisSourceMapper.map source }

      context 'when the target PPA::Theme does not exist' do
        it 'creates the target PPA::Theme' do
          expect { map }.to change { PPA::Theme.count }.by(1)

          target = PPA::Theme.last
          expect(target.code).to eq source.codigo_tema
          expect(target.name).to eq source.descricao_tema
        end

        # PATCH workaround para carregar dados, uma vez que o webservice do AxisTheme::Importer
        # está retornando '-' para os nomes de temas
        context 'when source has no name for the theme', :patch do
          before { source.update! descricao_tema: '-' }

          context 'and there is a source guideline with info about this theme' do
            let!(:guideline) do
              create :ppa_source_guideline,
                     codigo_eixo: source.codigo_eixo,
                     descricao_eixo: source.descricao_eixo,
                     codigo_tema: source.codigo_tema,
                     descricao_tema: 'Guideline defined theme name'
            end

            it 'fallbacks to the theme name from related source guideline (matching theme code)' do
              expect { map }.to change { PPA::Theme.count }.by(1)
              target = PPA::Theme.last
              expect(target).to have_attributes code: source.codigo_tema, name: 'Guideline defined theme name'
            end
          end

          context 'and there is no source guideline with info about this theme' do
            # on a different axis and/or theme
            let!(:guideline) { create :ppa_source_guideline }

            it 'does not fallback' do
              expect { map }.to change { PPA::Theme.count }.by(1)

              target = PPA::Theme.last
              expect(target.code).to eq source.codigo_tema
              expect(target.name).to eq source.descricao_tema
            end
          end
        end # patch


      end

      context 'when the target PPA::Theme already exists' do
        let!(:target) { create :ppa_theme, code: source.codigo_tema, axis: axis }

        it 'updates the target PPA::Theme' do
          expect do
            map
            target.reload
          end.to change { PPA::Theme.count }.by(0) # não cria nenhum registro
            .and change { target.name }.to(source.descricao_tema)
        end
      end
    end
  end

end
