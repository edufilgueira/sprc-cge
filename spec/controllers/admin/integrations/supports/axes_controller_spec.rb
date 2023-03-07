require 'rails_helper'

describe Admin::Integrations::Supports::AxesController do

  let(:user) { create(:user, :admin) }
  let(:axis) { create(:integration_supports_axis) }

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
        it 'axes' do
          expect(controller.axes).to eq([axis])
        end
      end

      describe '#sort' do
        let(:first_unsorted) do
          create(:integration_supports_axis, codigo_eixo: '123')
        end
        let(:last_unsorted) do
          create(:integration_supports_axis, codigo_eixo: '321')
        end
        before { sign_in(user) }

        it 'default' do
          Integration::Supports::Axis.delete_all

          first_unsorted
          last_unsorted

          get(:index)

          expect(controller.axes).to eq([first_unsorted, last_unsorted])
        end

        it 'sort_column param' do
          get :index, params: {sort_column: 'integration_supports_axes.descricao_eixo'}

          sorted = Integration::Supports::Axis.sorted('integration_supports_axes.descricao_eixo', 'asc')
          paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
          expected = paginated.to_sql

          result = controller.axes.to_sql

          expect(result).to eq(expected)
        end

        it 'sort_direction param' do
          get :index, params: {sort_column: 'integration_supports_axes.descricao_eixo', sort_direction: :desc}

          sorted = Integration::Supports::Axis.order('integration_supports_axes.descricao_eixo desc')
          paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
          expected = paginated.to_sql

          result = controller.axes.to_sql

          expect(result).to eq(expected)
        end

        it 'sort_columns helper' do
          expected = [
            'integration_supports_axes.codigo_eixo',
            'integration_supports_axes.descricao_eixo'
          ]

          expect(controller.sort_columns).to eq(expected)
        end
      end

      describe 'search' do
        it 'descricao_eixo' do
          axis
          searched_axis = create(:integration_supports_axis, descricao_eixo: 'ABCDEF')

          get(:index, params: { search: 'ABCDEF' })

          expect(controller.axes).to eq([searched_axis])
        end

        it 'codigo_eixo' do
          axis
          searched_axis = create(:integration_supports_axis, codigo_eixo: 'search_code')

          get(:index, params: { search: 'search_' })

          expect(controller.axes).to eq([searched_axis])
        end
      end
    end
  end

  describe '#show' do
    context 'unauthorized' do
      before { get(:show, params: { id: axis }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:show, params: { id: axis }) }

      describe 'helper methods' do
        it 'axis' do
          expect(controller.axis).to eq(axis)
        end
      end
    end
  end

end
