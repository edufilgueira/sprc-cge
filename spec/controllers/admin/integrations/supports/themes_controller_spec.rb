require 'rails_helper'

describe Admin::Integrations::Supports::ThemesController do
  let(:user) { create(:user, :admin) }
  let(:theme) { create(:integration_supports_theme) }

  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:index) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
      end

      describe 'helper methods' do
        it 'themes' do
          expect(controller.themes).to eq([theme])
        end
      end

      describe '#sort' do
        let(:first_unsorted) do
          create(:integration_supports_theme, codigo_tema: '123')
        end
        let(:last_unsorted) do
          create(:integration_supports_theme, codigo_tema: '321')
        end
        before { sign_in(user) }

        it 'default' do
          Integration::Supports::Theme.delete_all

          first_unsorted
          last_unsorted

          get(:index)

          expect(controller.themes).to eq([first_unsorted, last_unsorted])
        end

        it 'sort_column param' do
          get :index, params: {sort_column: 'integration_supports_themes.descricao_tema'}

          sorted = Integration::Supports::Theme.sorted('integration_supports_themes.descricao_tema', 'asc')
          paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
          expected = paginated.to_sql

          result = controller.themes.to_sql

          expect(result).to eq(expected)
        end

        it 'sort_direction param' do
          get :index, params: {sort_column: 'integration_supports_themes.descricao_tema', sort_direction: :desc}

          sorted = Integration::Supports::Theme.order('integration_supports_themes.descricao_tema desc')
          paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
          expected = paginated.to_sql

          result = controller.themes.to_sql

          expect(result).to eq(expected)
        end

        it 'sort_columns helper' do
          expected = [
            'integration_supports_themes.codigo_tema',
            'integration_supports_themes.descricao_tema'
          ]

          expect(controller.sort_columns).to eq(expected)
        end
      end

      describe 'search' do
        it 'descricao_tema' do
          theme
          searched_theme = create(:integration_supports_theme, descricao_tema: 'ABCDEF')

          get(:index, params: { search: 'ABCDEF' })

          expect(controller.themes).to eq([searched_theme])
        end

        it 'codigo_tema' do
          theme
          searched_theme = create(:integration_supports_theme, codigo_tema: 'search_code')

          get(:index, params: { search: 'search_' })

          expect(controller.themes).to eq([searched_theme])
        end
      end
    end
  end

  describe '#show' do
    context 'unauthorized' do
      before { get(:show, params: { id: theme }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:show, params: { id: theme }) }

      describe 'helper methods' do
        it 'theme' do
          expect(controller.theme).to eq(theme)
        end
      end
    end
  end

end
