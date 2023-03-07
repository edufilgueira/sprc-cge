# Shared example para action index com paginação

shared_examples_for 'controllers/transparency/base/index' do

  let(:current_year) { Date.today.year }
  let(:current_month) { Date.today.month }

  let(:stats_key) {
    # Ex: 'stats_expenses_ned'
    stats_model.model_name.param_key
  }

  describe '#index' do
    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/sorted'

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

    describe 'stats' do
      it 'stats' do
        if controller.send(:stats_yearly?)
          month_stats = create(stats_key, year: current_year, month: 0)
          another_stats = create(stats_key, year: current_year - 2, month: 0)
          expect(controller.last_stats_year).to eq(year)
        else
          month_stats = create(stats_key, year: current_year, month: current_month)
          another_stats = create(stats_key, year: current_year - 2, month: current_month)
          expect(controller.last_stats_month).to eq(Date.new(current_year, current_month))
        end

        expect(controller.stats).to eq(month_stats)
      end

      it 'stats based on stats_month_year or stats_year' do
        if controller.send(:stats_yearly?)
          month_stats = create(stats_key, year: current_year, month: 0)
          another_stats = create(stats_key, year: current_year - 2, month: 0)

          params = { stats_year: "#{another_stats.year}" }
        else
          month_stats = create(stats_key, year: current_year, month: current_month)
          another_stats = create(stats_key, year: current_year - 2, month: current_month)

          params = { stats_month_year: "#{another_stats.month}/#{another_stats.year}" }
        end

        get :index, params: params
        expect(controller.stats).to eq(another_stats)
      end
    end

    describe 'downloads' do
      it 'xlsx_download_path' do
        date = Date.new(current_year, current_month)

        if controller.send(:stats_yearly?)
          month_stats = create(stats_key, year: current_year, month: 0)
          year_month = date.year
          params = { stats_year: "#{current_year}" }
        else
          month_stats = create(stats_key, year: current_year, month: current_month)
          year_month = I18n.l(date, format: "%Y%m")
          params = { stats_month_year: "#{current_month}/#{current_year}" }
        end

        get :index, params: params

        expected = "/files/downloads/integration/#{spreadsheet_download_prefix}/#{year_month}/#{spreadsheet_file_prefix}_#{year_month}.xlsx"

        allow(File).to receive(:exists?).and_return(true)

        expect(controller.xlsx_download_path).to eq(expected)
      end

      it 'csv_download_path' do
        date = Date.new(current_year, current_month)
        year_month = I18n.l(date, format: "%Y%m")

        if controller.send(:stats_yearly?)
          month_stats = create(stats_key, year: current_year, month: 0)
          year_month = date.year
          params = { stats_year: "#{current_year}" }
        else
          month_stats = create(stats_key, year: current_year, month: current_month)
          year_month = I18n.l(date, format: "%Y%m")
          params = { stats_month_year: "#{current_month}/#{current_year}" }
        end

        get :index, params: params

        expected = "/files/downloads/integration/#{spreadsheet_download_prefix}/#{year_month}/#{spreadsheet_file_prefix}_#{year_month}.csv"

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
        month_stats = create(stats_key, year: current_year, month: current_month)

        if controller.send(:stats_yearly?)
          stats_month_year = "#{current_year}"

          params = { stats_year: stats_month_year }
        else
          stats_month_year = "#{current_month}/#{current_year}"

          params = { stats_month_year: stats_month_year }
        end

        get :index, params: params

        # - # É importante considerar o xlsx_download_path no cache pois pode ter sido cacheado enquanto
        # - # gerava a planilha e, com o cache, nunca apareceria para o download.

        csv_download_path = controller.csv_download_path
        xlsx_download_path = controller.xlsx_download_path
        transparency_id = controller.send(:transparency_id)
        cache_limited_by_day = controller.send(:cache_limited_by_day?)

        cache_prefix = "stats/#{transparency_id}/#{stats_month_year}/#{xlsx_download_path}/#{csv_download_path}"
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
