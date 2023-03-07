# Shared example para action index de transparency/revenues/transfers

shared_examples_for 'controllers/transparency/revenues/transfers/index' do

  let(:resources) { create_list(:integration_revenues_transfer, 1) }

  let(:transfer) { resources.first }

  let(:revenue) { transfer.revenue }

  let(:current_year) { Date.today.year }
  let(:current_month) { Date.today.month }

  let(:stats_key) {
    # Ex: 'stats_expenses_ned'
    stats_model.model_name.param_key
  }


  describe '#index' do

    describe 'templates' do
      render_views

      let(:controller_index_view_path) do
        controller.send(:index_view_path)
      end

      before { get(:index) }

      it 'responds with success and renders templates' do
        expect(response).to be_success
        expect(response).to render_template(controller_index_view_path)
      end

      describe 'assets' do
        it 'javascript' do
          expected = "views/#{controller_index_view_path}"
          expect(controller.javascript).to eq(expected)
        end
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

    #
    # Requisições relacionadas com abertura da árvore de receitas
    #
    describe 'nodes partial request' do
      it 'renders nodes partials' do

        get(:index, xhr: true, params: { node_path: "consolidado/100000000/secretary/19000000" })

        expect(response).not_to render_template('application')
        expect(response).not_to render_template('index')
        expect(response).not_to render_template(partial: '_index')
        expect(response).to render_template(partial: 'shared/transparency/revenues/transfers/index/_nodes')

        expect(controller.current_node_type).to eq(:secretary)
        expect(controller.next_node_type).to eq(:organ)
        expect(controller.current_node_level).to eq(1)
      end
    end

    describe 'helpers' do
      context 'year' do
        it 'value from params' do
          expected = '2017'

          get(:index, params: { year: expected })

          expect(controller.year).to eq(expected)
        end
      end
    end

    describe 'filters' do
      let(:current_date) { Date.today.beginning_of_month }
      let(:current_month) { current_date.month }
      let(:current_year) { current_date.year }

      let(:revenue_nature) { create(:integration_supports_revenue_nature, codigo: '117212220')}

      let(:organ) { create(:integration_supports_organ, orgao_sfp: false) }
      let(:another_organ) { create(:integration_supports_organ, orgao_sfp: false) }

      let(:revenue) { create(:integration_revenues_revenue, month: current_month, year: current_year, unidade: organ.codigo_orgao) }
      let(:transfer) { create(:integration_revenues_transfer, revenue: revenue, mes: current_month, conta_corrente: "#{revenue_nature.codigo}.20500") }

      let(:another_year_revenue) { create(:integration_revenues_revenue, month: current_month, year: current_year - 1, unidade: organ.codigo_orgao) }
      let(:another_year_transfer) { create(:integration_revenues_transfer, revenue: another_year_revenue, mes: current_month, conta_corrente: "#{revenue_nature.codigo}.20500") }

      let(:another_organ_revenue) { create(:integration_revenues_revenue, month: current_month, year: current_year, unidade: another_organ.codigo_orgao) }
      let(:another_organ_transfer) { create(:integration_revenues_transfer, revenue: another_organ_revenue, mes: current_month, conta_corrente: "#{revenue_nature.codigo}.20500") }

      it 'year' do
        transfer
        another_year_transfer

        current_year = revenue.year

        get(:index, xhr: true, params: { 'year': current_year })

        expect(controller.transfers).to match_array([transfer])
      end

      it 'organ' do
        transfer
        another_organ_transfer

        current_month = revenue.month
        current_year = revenue.year

        create(:stats_revenues_transfer, month: 0, month_start: 1, month_end: 1)
        
        get(:index, xhr: true, params: { unidade: organ.codigo_orgao })

        expect(controller.transfers).to match_array([transfer])
      end
    end

    describe 'stats' do
      it 'stats' do
        year_stats = create(stats_key, year: current_year, month: 0)
        another_stats = create(stats_key, year: current_year - 2, month: 0)

        expect(controller.stats).to eq(year_stats)
        expect(controller.last_stats_year).to eq(current_year)
      end

      it 'stats based on stats_year' do
        year_stats = create(stats_key, year: current_year, month: 0)
        another_stats = create(stats_key, year: current_year - 2, month: 0)

        params = { stats_year: another_stats.year }
        get :index, params: params
        expect(controller.stats).to eq(another_stats)
      end
    end

    describe 'downloads' do
      it 'xlsx_download_path' do

        year_stats = create(stats_key, year: current_year, month: 0)

        year = current_year

        params = { stats_year: current_year }

        get :index, params: params

        expected = "/files/downloads/integration/#{spreadsheet_download_prefix}/#{year}/#{spreadsheet_file_prefix}_#{year}.xlsx"

        allow(File).to receive(:exists?).and_return(true)

        expect(controller.xlsx_download_path).to eq(expected)
      end

      it 'csv_download_path' do
        year_stats = create(stats_key, year: current_year, month: 0)

        year = current_year

        params = { stats_year: current_year }

        get :index, params: params

        expected = "/files/downloads/integration/#{spreadsheet_download_prefix}/#{year}/#{spreadsheet_file_prefix}_#{year}.csv"

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

        expected = CacheHelper.cache_key_for(cache_key_prefix, controller.send(:resource_klass))

        expect(controller.cache_key).to eq(expected)
      end

      it 'stats_cache_key' do
        year_stats = create(stats_key, year: current_year, month: 0)

        date = Date.new(current_year, current_month)
        year_month = I18n.l(date, format: "%Y%m")

        stats_year = current_year

        params = { stats_year: stats_year }

        get :index, params: params

        # - # É importante considerar o xlsx_download_path no cache pois pode ter sido cacheado enquanto
        # - # gerava a planilha e, com o cache, nunca apareceria para o download.

        csv_download_path = controller.csv_download_path
        xlsx_download_path = controller.xlsx_download_path
        transparency_id = controller.send(:transparency_id)
        cache_limited_by_day = controller.send(:cache_limited_by_day?)

        cache_prefix = "stats/#{transparency_id}/#{stats_year}/#{xlsx_download_path}/#{csv_download_path}"
        cache_prefix += "/#{Date.today.end_of_day}" if cache_limited_by_day

        expected = CacheHelper.cache_key_for(cache_prefix, stats_model)

        expect(controller.stats_cache_key).to eq(expected)
      end
    end
  end

  private

  def resource_model
    controller.send(:resource_klass)
  end

  def stats_model
    controller.send(:stats_klass)
  end

  def spreadsheet_download_prefix
    controller.send(:spreadsheet_download_prefix)
  end

  def spreadsheet_file_prefix
    controller.send(:spreadsheet_file_prefix)
  end
end
