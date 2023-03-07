require 'rails_helper'

describe Admin::Integrations::Supports::CreditorsController do

  let(:user) { create(:user, :admin) }
  let(:creditor) { create(:integration_supports_creditor) }

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
        it 'creditors' do
          expect(controller.creditors).to eq([creditor])
        end
      end

      describe '#sort' do
        let(:first_unsorted) do
          create(:integration_supports_creditor, nome: 'Maria')
        end
        let(:last_unsorted) do
          create(:integration_supports_creditor, nome: 'Ana')
        end
        before { sign_in(user) }

        it 'default' do
          Integration::Supports::Creditor.delete_all

          first_unsorted
          last_unsorted

          get(:index)

          expect(controller.creditors).to eq([last_unsorted, first_unsorted])
        end

        it 'sort_column param' do
          get :index, params: {sort_column: 'integration_supports_creditors.descricao_orgao'}

          sorted = Integration::Supports::Creditor.sorted('integration_supports_creditors.descricao_orgao', 'asc')
          paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
          expected = paginated.to_sql

          result = controller.creditors.to_sql

          expect(result).to eq(expected)
        end

        it 'sort_direction param' do
          get :index, params: {sort_column: 'integration_supports_creditors.descricao_orgao', sort_direction: :desc}

          sorted = Integration::Supports::Creditor.order('integration_supports_creditors.descricao_orgao desc')
          paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
          expected = paginated.to_sql

          result = controller.creditors.to_sql

          expect(result).to eq(expected)
        end

        it 'sort_columns helper' do
          expected = [
            'integration_supports_creditors.nome',
            'integration_supports_creditors.codigo',
            'integration_supports_creditors.status'
          ]

          expect(controller.sort_columns).to eq(expected)
        end
      end

      describe 'search' do
        it 'codigo' do
          creditor
          searched_creditor = create(:integration_supports_creditor, codigo: 'abc')

          get(:index, params: { search: 'bc' })

          expect(controller.creditors).to eq([searched_creditor])
        end

        it 'nome' do
          creditor
          searched_creditor = create(:integration_supports_creditor, nome: 'MARIA TEREZA B DE MENEZES FONTENELE')

          get(:index, params: { search: 'Mar' })

          expect(controller.creditors).to eq([searched_creditor])
        end

        it 'cpf_cnpj' do
          creditor
          searched_creditor = create(:integration_supports_creditor, cpf_cnpj: '123.456.789-21')

          get(:index, params: { search: '456' })

          expect(controller.creditors).to eq([searched_creditor])
        end

        it 'email' do
          creditor
          searched_creditor = create(:integration_supports_creditor, email: 'maria@example.com')

          get(:index, params: { search: 'rIa' })

          expect(controller.creditors).to eq([searched_creditor])
        end

        it 'telefone_contato' do
          creditor
          searched_creditor = create(:integration_supports_creditor, telefone_contato: '19 9 9999-9999')

          get(:index, params: { search: '99' })

          expect(controller.creditors).to eq([searched_creditor])
        end

      end

    end
  end

  describe '#show' do
    context 'unauthorized' do
      before { get(:show, params: { id: creditor }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:show, params: { id: creditor }) }

      describe 'helper methods' do
        it 'creditor' do
          expect(controller.creditor).to eq(creditor)
        end
      end
    end
  end

end
