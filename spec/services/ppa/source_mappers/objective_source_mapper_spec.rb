require 'rails_helper'

describe PPA::SourceMappers::ObjectiveSourceMapper do


  describe '::map' do
    let!(:source) { create :ppa_source_guideline }
    let!(:mapper) { described_class.new source }
    subject(:map) { mapper.map }

    context 'blacklist' do
      it "ignores source with objective code '-' (missing)" do
        source.update! codigo_ppa_objetivo_estrategico: '-'
        expect(mapper).to be_blacklisted
      end
    end

    context 'pre-requisites' do
      context 'when the related Theme does not exist' do
        it 'raises error' do
          expect { map }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'with all pre-requisites satisfied' do
      let!(:axis) { create :ppa_axis, code: source.codigo_eixo, name: source.descricao_eixo }
      let!(:theme) { create :ppa_theme, code: source.codigo_tema, name: source.descricao_tema, axis: axis }

      context 'when the target Objective does not exist' do
        it 'creates the target Objective' do
          expect { map }.to change { PPA::Objective.count }.by(1)

          target = PPA::Objective.last
          expect(target.code).to eq source.codigo_ppa_objetivo_estrategico
          expect(target.name).to eq source.descricao_objetivo_estrategico
        end

        it 'associates Objective and Theme' do
          expect { map }.to change { theme.objectives.count }.by(1)

          target = PPA::Objective.last
          associated_theme = theme
          expect(target.theme_ids).to include associated_theme.id
        end
      end

      context 'when the target Objective already exists' do
        let!(:target) { create :ppa_objective, code: source.codigo_ppa_objetivo_estrategico }

        it 'updates the target PPA::Objective' do
          expect do
            map
            target.reload
          end.to change { PPA::Objective.count }.by(0) # não cria nenhum registro
            .and change { target.name }.to(source.descricao_objetivo_estrategico)
        end

        context 'when the target Objective has no associated Theme' do
          it 'associates Objective and Theme' do
            expect { map }.to change { target.themes.count }.by(1)

            associated_theme = theme
            expect(target.theme_ids).to include associated_theme.id
          end
        end

        context 'when the target Objective already has the associated Theme' do
          # garantindo a associação
          before { target.themes << theme }

          it 'does not associate Objective and Theme' do
            expect { map }.not_to change { target.themes.count }
          end
        end
      end
    end
  end

end
