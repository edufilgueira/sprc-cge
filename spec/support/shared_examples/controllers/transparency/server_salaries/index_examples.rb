# Shared example para action index de transparency/server_salaries

shared_examples_for 'controllers/transparency/server_salaries/index' do

  let(:server_salary) { create(:integration_servers_server_salary) }
  let(:current_date) { Date.today.beginning_of_month }
  let(:current_month) { current_date.month }
  let(:current_year) { current_date.year }
  let(:current_month_year) { I18n.l(current_date, format: :month_year) }

  describe '#index' do
    before { get(:index) }

    context 'template' do
      render_views

      it 'responds with success and renders templates' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/server_salaries/index')
        expect(response).to render_template('shared/transparency/server_salaries/index/_filters')
      end
    end

    describe 'assets' do
      it 'javascript' do
        expected = 'views/shared/transparency/server_salaries/index'
        expect(controller.javascript).to eq(expected)
      end
    end

    describe 'xhr' do
      it 'does not render layout and renders only _index partial' do
        get(:index, xhr: true)

        expect(response).not_to render_template('application')
        expect(response).not_to render_template('index')
        expect(response).to render_template(partial: '_index')
      end

      it 'renders stats partial' do
        get(:index, params: { show_stats: true }, xhr: true)

        expect(response).not_to render_template('application')
        expect(response).not_to render_template('index')
        expect(response).not_to render_template(partial: '_index')
        expect(response).to render_template(partial: '_stats')
      end
    end

    describe 'paginate' do
      it 'calls kaminari methods' do
        allow(server_salary.class).to receive(:page).and_call_original
        expect(server_salary.class).to receive(:page).and_call_original
        controller.server_salaries
      end
    end

    describe 'sort' do
      it 'sort_columns helper' do
        expected = [
          'integration_servers_server_salaries.server_name',
          'integration_supports_organs.sigla',
          'integration_supports_server_roles.name',
          'integration_servers_registrations.functional_status',
          'integration_servers_server_salaries.income_total',
          'integration_servers_server_salaries.income_final'
        ]

        expect(controller.sort_columns).to eq(expected)
      end
    end

    describe 'search' do
      # os testes de filtro por busca textual ficam em
      # models/<nome_do_model>/search_spec.rb.
      # Precisamos apenas testar se o método é invocado.

      it 'calls search with params[:search]' do
        allow(server_salary.class).to receive(:search).with('search', any_args).and_call_original

        expect(server_salary.class).to receive(:search).with('search', any_args).and_call_original

        get(:index, xhr: true, params: { search: 'search' })

        # para acionar a busca é preciso acessar o recurso pois é lazy_loaded
        controller.server_salaries
      end
    end

    describe 'filters' do
      context 'association' do
        it 'organ' do
          another_server_salary = create(:integration_servers_server_salary)
          another_organ = another_server_salary.organ

          filtered_organ = server_salary.organ

          expect(filtered_organ).not_to eq(another_organ)

          get(:index, xhr: true, params: { 'integration_servers_registrations.cod_orgao': filtered_organ.codigo_folha_pagamento })

          expect(controller.server_salaries).to match_array([server_salary])
        end

        it 'role' do
          another_server_salary = create(:integration_servers_server_salary)
          another_role = another_server_salary.role

          filtered_role = server_salary.role

          expect(filtered_role).not_to eq(another_role)

          get(:index, xhr: true, params: { integration_supports_server_role_id: filtered_role.id })

          expect(controller.server_salaries).to match_array([server_salary])
        end
      end

      it 'month_year' do
        current_month = server_salary.date.month
        current_year = server_salary.date.year

        month_year = "#{current_month}/#{current_year}"

        another_server_salary = create(:integration_servers_server_salary, date: current_date - 1.year)

        get(:index, xhr: true, params: { 'month_year': month_year })

        expect(controller.server_salaries).to match_array([server_salary])
      end

      it 'functional_status' do
        registration = create(:integration_servers_registration, functional_status: 1)
        another_registration = create(:integration_servers_registration, functional_status: 2)

        server_salary = create(:integration_servers_server_salary, registration: registration)
        another_server_salary = create(:integration_servers_server_salary, registration: another_registration)

        get(:index, xhr: true, params: { 'functional_status': 2 })

        expect(controller.server_salaries).to match_array([another_server_salary])
      end
    end

    describe 'helpers' do
      context 'month_year' do
        it 'value from params' do
          expected = '09/2017'

          get(:index, params: { month_year: expected })

          expect(controller.month_year).to eq(expected)
        end

        it 'defaults value to last server_salary date' do
          expected_date = Date.today - 2.month
          create(:integration_servers_server_salary, date: expected_date)

          create(:integration_servers_server_salary, date: expected_date - 2.month)

          expected = I18n.l(expected_date, format: :month_year)

          get(:index, params: { month_year: '' })

          expect(controller.month_year).to eq(expected)
        end

        it 'defaults value to Date.today params' do
          expected = I18n.l(Date.today, format: :month_year)

          get(:index, params: { month_year: '' })

          expect(controller.month_year).to eq(expected)
        end
      end

      it 'date' do
        month_year = '09/2017'
        expected = Date.new(2017, 9)

        get(:index, params: { month_year: month_year })

        expect(controller.date).to eq(expected)
      end

      context 'server_salaries' do
        it 'return from default month_year' do
          server_salary = create(:integration_servers_server_salary, date: current_date)
          another_server_salary = create(:integration_servers_server_salary, date: current_date - 1.year)

          expect(controller.server_salaries).to match_array([server_salary])
        end
      end

      context 'filters' do
        it 'filtered_count and total_count' do
          server_salary = create(:integration_servers_server_salary, server_name: 'found', date: current_date)
          server_salary_another_name = create(:integration_servers_server_salary, date: current_date)
          another_server_salary = create(:integration_servers_server_salary, server_name: 'found', date: current_date - 1.year)

          month_year = "#{current_month}/#{current_year}"

          get(:index, params: { search: 'found' })

          expect(controller.filtered_count).to eq(1)
          expect(controller.total_count).to eq(2) # deve estar escopado por data!
        end
      end

      describe 'stats' do
        it 'stats' do
          month_stats = create(:stats_server_salary, year: current_year, month: current_month)
          another_stats = create(:stats_server_salary, year: current_year - 2, month: current_month)

          expect(controller.stats).to eq(month_stats)
          expect(controller.last_stats_month).to eq(Date.new(current_year, current_month))
        end

        it 'available_stats_months' do
          month_stats = create(:stats_server_salary, year: current_year, month: current_month)
          another_stats = create(:stats_server_salary, year: current_year - 2, month: current_month)

          first_date = Date.new(current_year - 2, current_month)
          second_date = Date.new(current_year, current_month)

          expected = [
            I18n.l(first_date, format: :month_year),
            I18n.l(second_date, format: :month_year)
          ]

          expect(controller.available_stats_months).to eq(expected)
        end

        it 'stats based on stats_month_year' do
          month_stats = create(:stats_server_salary, year: current_year, month: current_month)
          another_stats = create(:stats_server_salary, year: current_year - 2, month: current_month)

          params = { stats_month_year: "#{another_stats.month}/#{another_stats.year}" }
          get :index, params: params
          expect(controller.stats).to eq(another_stats)
        end
      end

      describe 'sums and counts' do
        it 'income_total_sum' do
          first = create(:integration_servers_server_salary, date: current_date, income_total: 10, discount_under_roof: 2)
          second = create(:integration_servers_server_salary, date: current_date, income_total: 20, discount_under_roof: 4)

          ignored = create(:integration_servers_server_salary, date: current_date + 2.year, income_total: 100, discount_under_roof: 20)

          params = { month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expect(controller.income_total_sum).to eq(30 - 6) # income_total - dicount_under_roof
        end

        it 'unique_servers_count' do
          first = create(:integration_servers_server_salary, date: current_date, income_total: 10, discount_under_roof: 1)

          registration = first.registration
          server = registration.server

          another_registration = create(:integration_servers_registration, server: server)

          first = create(:integration_servers_server_salary, date: current_date, income_total: 10, discount_under_roof: 2)
          second = create(:integration_servers_server_salary, date: current_date, income_total: 20, discount_under_roof: 4)
          third = create(:integration_servers_server_salary, date: current_date, registration: another_registration, income_total: 30, discount_under_roof: 6)

          ignored = create(:integration_servers_server_salary, date: current_date + 2.year, income_total: 100, discount_under_roof: 20)

          params = { month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expect(controller.income_total_sum).to eq(70 - 13)
          expect(controller.unique_servers_count).to eq(3)
        end
      end

      describe 'downloads' do
        it 'xlsx_download_path' do

          month_stats = create(:stats_server_salary, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          params = { stats_month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expected = "/files/downloads/integration/servers/server_salaries/#{year_month}/servidores_#{year_month}.xlsx"

          allow(File).to receive(:exists?).and_return(true)

          expect(controller.xlsx_download_path).to eq(expected)
        end

        it 'csv_download_path' do

          month_stats = create(:stats_server_salary, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          params = { stats_month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expected = "/files/downloads/integration/servers/server_salaries/#{year_month}/servidores_#{year_month}.csv"

          allow(File).to receive(:exists?).and_return(true)

          expect(controller.csv_download_path).to eq(expected)
        end
      end


      describe 'cache' do
        it 'cache_key' do
          # É importante que a chave do cache considere TODOS os parâmetros que possam
          # alterar a view: page, sort_column, ...,. Além dos parâmetros do próprio
          # model.

          get :index, params: { search: '123' }

          allow(Digest::SHA256).to receive(:hexdigest).and_return('abcde')

          cache_params = controller.params.permit!.to_h.to_s
          params_digest = Digest::SHA256.hexdigest(cache_params)

          # É importante usar o namespace no cache pois os links para show_path
          # das ferramentas de transparência que são compartilhadas por diversos
          # namespaces (:admin, :platform, ...) deve ser específicos.

          namespace = controller.namespace

          cache_key_prefix = "#{namespace}/#{params_digest}"

          expected = CacheHelper.cache_key_for(cache_key_prefix, Integration::Servers::ServerSalary)

          expect(controller.cache_key).to eq(expected)
        end

        it 'stats_cache_key' do
          month_stats = create(:stats_server_salary, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          stats_month_year = "#{current_month}/#{current_year}"

          params = { stats_month_year: stats_month_year }

          get :index, params: params

          # - # É importante considerar o xlsx_download_path no cache pois pode ter sido cacheado enquanto
          # - # gerava a planilha e, com o cache, nunca apareceria para o download.

          csv_download_path = controller.csv_download_path
          xlsx_download_path = controller.xlsx_download_path
          cache_prefix = "stats/server_salaries/#{stats_month_year}/#{xlsx_download_path}/#{csv_download_path}"

          expected = CacheHelper.cache_key_for(cache_prefix, Stats::ServerSalary)

          expect(controller.stats_cache_key).to eq(expected)
        end
      end
    end
  end
end
