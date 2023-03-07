require 'rails_helper'

describe Admin::Integrations::Supports::OrgansController do

  let(:user) { create(:user, :admin) }
  let(:organ) { create(:integration_supports_organ) }

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
        it 'organs' do
          expect(controller.organs).to eq([organ])
        end
      end

      describe '#sort' do
        let(:first_unsorted) do
          create(:integration_supports_organ, codigo_orgao: '123')
        end
        let(:last_unsorted) do
          create(:integration_supports_organ, codigo_orgao: '321')
        end
        before { sign_in(user) }

        it 'default' do
          Integration::Supports::Organ.delete_all

          first_unsorted
          last_unsorted

          get(:index)

          expect(controller.organs).to eq([first_unsorted, last_unsorted])
        end

        it 'sort_column param' do
          get :index, params: {sort_column: 'integration_supports_organs.descricao_orgao'}

          sorted = Integration::Supports::Organ.sorted('integration_supports_organs.descricao_orgao', 'asc')
          paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
          expected = paginated.to_sql

          result = controller.organs.to_sql

          expect(result).to eq(expected)
        end

        it 'sort_direction param' do
          get :index, params: {sort_column: 'integration_supports_organs.descricao_orgao', sort_direction: :desc}

          sorted = Integration::Supports::Organ.order('integration_supports_organs.descricao_orgao desc')
          paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
          expected = paginated.to_sql

          result = controller.organs.to_sql

          expect(result).to eq(expected)
        end

        it 'sort_columns helper' do
          expected = [
            'integration_supports_organs.codigo_entidade',
            'integration_supports_organs.descricao_entidade',
            'integration_supports_organs.codigo_orgao',
            'integration_supports_organs.sigla',
            'integration_supports_organs.descricao_orgao',
            'integration_supports_organs.data_inicio',
            'integration_supports_organs.data_termino',
            'integration_supports_organs.orgao_sfp'
          ]

          expect(controller.sort_columns).to eq(expected)
        end
      end

      describe 'search' do
        it 'descricao_orgao' do
          organ
          searched_organ = create(:integration_supports_organ, descricao_orgao: 'ABCDEF')

          get(:index, params: { search: 'ABCDEF' })

          expect(controller.organs).to eq([searched_organ])
        end

        it 'codigo_orgao' do
          organ
          searched_organ = create(:integration_supports_organ, codigo_orgao: 'search_code')

          get(:index, params: { search: 'search_' })

          expect(controller.organs).to eq([searched_organ])
        end

        it 'sigla' do
          organ
          searched_organ = create(:integration_supports_organ, sigla: 'PM')

          get(:index, params: { search: 'Pm' })

          expect(controller.organs).to eq([searched_organ])
        end

      end

    end
  end

  describe '#show' do
    context 'unauthorized' do
      before { get(:show, params: { id: organ }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:show, params: { id: organ }) }

      describe 'helper methods' do
        it 'organ' do
          expect(controller.organ).to eq(organ)
        end
      end
    end
  end

end
