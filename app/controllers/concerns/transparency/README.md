# CRUD Básico de Transparência

## Instruções básicas


**1) O crud deve ser shared (namespaces: plataform e admin);**

**2) O crud deve ter um `transparency_id`, como por ex: 'expenses/neds', 'purchases', etc.**

   O `transparency_id` é usado pelo Transparency::BaseController para uma série de funções, como renderizar as views compartilhadas, locales, etc.


## Controllers

### BaseController

  Controller que será incluído nos controllers específicos de cada namespace (admin e transparency, por exemplo).

  - app/concerns/controllers/transparency/{transparency_id}/base_controller.rb

  - Deve sobrescrever os seguintes métodos privados:

    - `resource_klass` (ex: Integration::Expenses::Ned)

    - `transparency_id` (ex: 'expenses/neds')

    - `filtered_sum_column` (ex: :valor)

    - `spreadsheet_file_prefix` (ex: :neds)

    - `stats_klass` (ex: Stats::Expenses::Ned)

  - Deve implementar os helper methods de acordo com o model:

    Exemplo:

    ```ruby
      ...
      included do

        helper_method [
          :neds,

          :ned,
          :ned_items,
          ...
        ]

        # Helper methods

        def neds
          # Só precisamos usar o paginated_resources (PaginatedController)
          # que utilizado o filtered_resources (FilteredController)
          paginated_resources
        end

        def ned
          resource
        end

        def ned_items
          ned.ned_items.sorted
        end
        ...
    ```

### Controller da área de Transparência

  Controller da área específica de transparência. Deve incluir seu prório breadcrumb e o base_controller.

  Exemplo:

  - Controller

  ```ruby
    class Transparency::Expenses::NedsController < TransparencyController
      include Transparency::Expenses::Neds::Breadcrumbs
      include Transparency::Expenses::Neds::BaseController

    end
  ```

  - Breadcrumbs

  ```ruby
    module Transparency::Expenses::Neds::Breadcrumbs

      protected

      def index_breadcrumbs
        [
          [t('transparency.home.index.title'), transparency_root_path],
          [t('transparency.expenses.neds.index.title'), '']
        ]
      end

      def show_edit_update_breadcrumbs
        [
          [t('transparency.home.index.title'), transparency_root_path],
          [t('transparency.expenses.neds.index.title'), transparency_expenses_neds_path],
          [ned.title, '']
        ]
      end
    end
  ```

### Controller da área administrativa

  Controller da área administrativa. Deve incluir seu prório breadcrumb e o base_controller.

  Exemplo:

  - Controller

  ```ruby
    class Admin::Integrations::Expenses::NedsController < AdminController
      include Admin::Integrations::Expenses::Neds::Breadcrumbs
      include Transparency::Expenses::Neds::BaseController

    end
  ```


  - Breadcrumbs

  ```ruby
    module Admin::Integrations::Expenses::Neds::Breadcrumbs
      include Admin::Integrations::Breadcrumbs

      protected

      def index_breadcrumbs
        [
          [t('admin.home.index.title'), admin_root_path],
          [t('admin.integrations.index.title'), admin_integrations_root_path],
          [t('admin.integrations.expenses.index.title'), admin_integrations_expenses_root_path],
          [t('.title'), '']
        ]
      end

      def show_edit_update_breadcrumbs
        integrations_index_breadcrumbs +
        [
          [t('admin.integrations.expenses.index.title'), admin_integrations_expenses_root_path],
          [t('admin.integrations.expenses.neds.index.title'), admin_integrations_expenses_neds_path],
          [ned.title, '']
        ]
      end
    end

  ```

## Testes

  Deve haver shared_example de testes para a action `index` e `show` do controller.

### Shared examples

Exemplo de shared example para action index:

  ```ruby
    # Shared example para action index de transparency/expenses/neds

    shared_examples_for 'controllers/transparency/expenses/neds/index' do

      let(:resources) { create_list(:integration_expenses_ned, 1) }

      let(:ned) { resources.first }

      it_behaves_like 'controllers/transparency/base/index' do
        let(:sort_columns) do
          [
            'integration_expenses_neds.numero',
            'integration_expenses_neds.date_of_issue',
            'integration_supports_organs.descricao_orgao',
            'integration_supports_creditors.nome',
            'integration_expenses_neds.valor',
            'integration_expenses_neds.valor_pago'
          ]
        end

        describe 'search' do
          it 'unidade_gestora' do
            ned
            searched_ned = create(:integration_expenses_ned, unidade_gestora: 'ABCDEF')

            get(:index, params: { search: 'ABCDEF' })

            expect(controller.neds).to eq([searched_ned])
          end

          it 'especificacao_geral' do
            ned
            searched_ned = create(:integration_expenses_ned, especificacao_geral: 'especificacao_geral')

            get(:index, params: { search: 'ger' })

            expect(controller.neds).to eq([searched_ned])
          end

          it 'creditor_nome' do
            creditor = create(:integration_supports_creditor, nome: 'João da silva')
            searched_ned = create(:integration_expenses_ned, creditor: creditor)
            ned

            get(:index, params: { search: 'silva' })

            expect(controller.neds).to eq([searched_ned])
          end
        end

        describe 'filters' do
          it 'by range' do
            ned = create(:integration_expenses_ned, data_emissao: '29/12/2016')
            ned
            first_filtered = create(:integration_expenses_ned, data_emissao: '01/01/2017')
            middle_filtered = create(:integration_expenses_ned, data_emissao: '31/12/2016')
            last_filtered = create(:integration_expenses_ned, data_emissao: '30/12/2016')

            get(:index, params: { date_of_issue: '30/12/2016 - 01/01/2017' })

            expect(controller.neds).to eq([first_filtered, middle_filtered, last_filtered])
          end

          it 'by unidade_gestora' do
            organ = create(:integration_supports_organ, codigo_orgao: '1234')

            ned = create(:integration_expenses_ned, unidade_gestora: 'NOT_FOUND')
            ned_filtered = create(:integration_expenses_ned, unidade_gestora: organ.codigo_orgao)

            get(:index, params: { unidade_gestora: organ.codigo_orgao })

            expect(controller.neds).to eq([ned_filtered])
          end

          describe 'helper methods' do
            it 'filtered_count' do
              ned
              filtered = create(:integration_expenses_ned, numero: '987')

              get(:index, params: { search: '987' })

              expect(controller.filtered_count).to eq(1)
            end

            it 'filtered_sum' do
              ned
              filtered = create(:integration_expenses_ned, numero: '987')

              get(:index, params: { search: '987' })

              filtered_sum_column = controller.send(:filtered_sum_column)

              expect(controller.filtered_sum).to eq(filtered.send(filtered_sum_column))
            end
          end
        end
      end
    end

  ```

Exemplo de shared example para action show:

  ```ruby
    # Shared example para action show de transparency/expenses/neds

    shared_examples_for 'controllers/transparency/expenses/neds/show' do

      let(:resources) { create_list(:integration_expenses_ned, 1) }

      let(:ned) { resources.first }

      it_behaves_like 'controllers/transparency/base/show' do
        before { get(:show, params: { id: ned }) }

        let(:ned_item) { create(:integration_expenses_ned_item, ned: ned) }
        let(:ned_planning_item) { create(:integration_expenses_ned_planning_item, ned: ned) }
        let(:ned_disbursement_forecast) { create(:integration_expenses_ned_disbursement_forecast, ned: ned) }

        describe 'helper methods' do
          it 'ned' do
            expect(controller.ned).to eq(ned)
          end
          it 'ned_item' do
            expect(controller.ned_items).to eq([ned_item])
          end
          it 'ned_planning_items' do
            expect(controller.ned_planning_items).to eq([ned_planning_item])
          end
          it 'ned_disbursement_forecasts' do
            expect(controller.ned_disbursement_forecasts).to eq([ned_disbursement_forecast])
          end
        end

        describe 'templates' do
          render_views

          it 'responds with success and renders views without errors' do
            expect(response).to be_success
            expect(response).to render_template('shared/transparency/expenses/neds/show')
            expect(response).to render_template('shared/transparency/expenses/neds/show/_ned_disbursement_forecasts')
            expect(response).to render_template('shared/transparency/expenses/neds/show/_ned_items')
            expect(response).to render_template('shared/transparency/expenses/neds/show/_ned_planning_items')
          end
        end
      end
    end
  ```

### Testes da área de Transparência

Exemplo de teste de controller:

  ```ruby
    require 'rails_helper'

    describe Transparency::Expenses::NedsController do
      describe '#index' do
        it_behaves_like 'controllers/transparency/expenses/neds/index'
      end

      describe '#show' do
        it_behaves_like 'controllers/transparency/expenses/neds/show'
      end
    end
  ```

Exemplo de teste de breadcrumbs:

  ```ruby

    require 'rails_helper'

    describe Transparency::Expenses::NedsController do

      let(:ned) { create(:integration_expenses_ned) }

      context 'index' do
        before { get(:index) }

        it 'breadcrumbs' do
          expected = [
            { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
            { title: I18n.t('transparency.expenses.neds.index.title'), url: '' }
          ]

          expect(controller.breadcrumbs).to eq(expected)
        end
      end

      context 'show' do
        before { get(:show, params: { id: ned }) }

        it 'breadcrumbs' do
          expected = [
            { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
            { title: I18n.t('transparency.expenses.neds.index.title'), url: transparency_expenses_neds_path },
            { title: ned.title, url: '' }
          ]

          expect(controller.breadcrumbs).to eq(expected)
        end
      end
    end
  ```


### Testes da área administrativa

Exemplo de teste de controller:

  ```ruby
    require 'rails_helper'

    describe Admin::Integrations::Expenses::NedsController do

      let(:user) { create(:user, :admin) }

      describe '#index' do
        context 'unauthorized' do
          before { get(:index) }

          it { is_expected.to redirect_to(new_user_session_path) }
        end

        context 'authorized' do
          before { sign_in(user) }

          it_behaves_like 'controllers/transparency/expenses/neds/index'
        end
      end

      describe '#show' do
        context 'unauthorized' do
          before { get(:show, params: { id: 1 }) }

          it { is_expected.to redirect_to(new_user_session_path) }
        end

        context 'authorized' do
          before { sign_in(user) }

          it_behaves_like 'controllers/transparency/expenses/neds/show'
        end
      end

    end
  ```

Exemplo de teste de breadcrumbs:

  ```ruby
    require 'rails_helper'

    describe Admin::Integrations::Expenses::NedsController  do

      let(:user) { create(:user, :admin) }
      let(:ned) { create(:integration_expenses_ned) }


      context 'index' do
        before { sign_in(user) && get(:index) }

        it 'breadcrumbs' do
          expected = [
            { title: I18n.t('admin.home.index.title'), url: admin_root_path },
            { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
            { title: I18n.t('admin.integrations.expenses.index.title'), url: admin_integrations_expenses_root_path },
            { title: I18n.t('admin.integrations.expenses.neds.index.title'), url: '' }
          ]

          expect(controller.breadcrumbs).to eq(expected)
        end
      end

      context 'show' do
        before { sign_in(user) && get(:show, params: { id: ned }) }

        it 'breadcrumbs' do
          expected = [
            { title: I18n.t('admin.home.index.title'), url: admin_root_path },
            { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
            { title: I18n.t('admin.integrations.expenses.index.title'), url: admin_integrations_expenses_root_path },
            { title: I18n.t('admin.integrations.expenses.neds.index.title'), url: admin_integrations_expenses_neds_path },
            { title: ned.title, url: '' }
          ]

          expect(controller.breadcrumbs).to eq(expected)
        end
      end

    end
  ```

## Views

  > [TODO]


## Locales

  > [TODO]


## Importer

  > [TODO]

## Stats

  > [TODO]

## Spreadsheets

  > [TODO]
