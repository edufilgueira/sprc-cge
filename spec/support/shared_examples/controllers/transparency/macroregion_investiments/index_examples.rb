# Shared example para action index de transparency/macroregion_investiments

shared_examples_for 'controllers/transparency/macroregion_investiments/index' do

  let(:current_year) { Date.today.year }
  let(:current_month) { Date.today.month }
  let(:macroregion_investiment) { create(:integration_macroregions_macroregion_investiment) }

  describe '#index' do
    context 'template' do

      render_views

      before { get(:index) }

      it 'responds with success and renders templates' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/macroregion_investiments/index')
      end

      describe 'assets' do
        it 'javascript' do
          expected = 'views/shared/transparency/macroregion_investiments/index'
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
    end

    describe 'paginate' do
      it 'calls kaminari methods' do
        allow(macroregion_investiment.class).to receive(:page).and_call_original
        expect(macroregion_investiment.class).to receive(:page).and_call_original
        controller.macroregion_investiments
      end
    end

    describe 'sort' do
      let(:first_unsorted) do
        create(:integration_macroregions_macroregion_investiment, valor_lei: '123')
      end
      let(:last_unsorted) do
        create(:integration_macroregions_macroregion_investiment, valor_lei: '456')
      end
      it 'default' do
        Integration::Macroregions::MacroregionInvestiment.delete_all

        first_unsorted
        last_unsorted

        get(:index)

        expect(controller.macroregion_investiments).to eq([last_unsorted, first_unsorted])
      end

      it 'sort_column param' do
        get :index, params: { sort_column: 'integration_macroregions_macroregion_investiments.valor_lei' }

        scope = Integration::Macroregions::MacroregionInvestiment.search_scope
        sorted = scope.sorted('integration_macroregions_macroregion_investiments.valor_lei', 'desc')
        paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
        expected = paginated.to_sql

        result = controller.macroregion_investiments.to_sql

        expect(result).to eq(expected)
      end

      it 'sort_direction param' do
        get :index, params: { sort_column: 'integration_macroregions_macroregion_investiments.valor_lei', sort_direction: :desc }

        scope = Integration::Macroregions::MacroregionInvestiment.search_scope
        sorted = scope.order('integration_macroregions_macroregion_investiments.valor_lei desc')
        paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
        expected = paginated.to_sql

        result = controller.macroregion_investiments.to_sql

        expect(result).to eq(expected)
      end

      it 'sort_columns helper' do
        expected = %w[
          integration_macroregions_macroregion_investiments.descricao_poder
          integration_macroregions_macroregion_investiments.descricao_regiao
          integration_macroregions_macroregion_investiments.valor_lei
          integration_macroregions_macroregion_investiments.valor_lei_creditos
          integration_macroregions_macroregion_investiments.valor_empenhado
          integration_macroregions_macroregion_investiments.valor_pago
          integration_macroregions_macroregion_investiments.perc_pago_calculated
        ]

        expect(controller.sort_columns).to eq(expected)
      end

      describe 'stats' do
        it 'stats' do
          month_stats = create(:stats_macroregian_investment, year: current_year, month: current_month)
          another_stats = create(:stats_macroregian_investment, year: current_year - 2, month: current_month)

          expect(controller.stats).to eq(month_stats)
          expect(controller.last_stats_month).to eq(Date.new(current_year, current_month))
        end

        it 'stats based on stats_year' do
          month_stats = create(:stats_macroregian_investment, year: current_year)
          another_stats = create(:stats_macroregian_investment, year: current_year - 2)

          params = { stats_year: "#{another_stats.year}" }
          get :index, params: params
          expect(controller.stats).to eq(another_stats)
        end
      end
    end

    describe 'helper methods' do
      it 'macroregion_investiments' do
        expect(controller.macroregion_investiments).to eq([macroregion_investiment])
      end

      describe 'downloads' do
        it 'xlsx_download_path' do

          month_stats = create(:stats_macroregian_investment, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          params = { stats_month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expected = "/files/downloads/integration/macroregions/#{year_month}/macroregions_#{year_month}.xlsx"

          allow(File).to receive(:exists?).and_return(true)

          expect(controller.xlsx_download_path).to eq(expected)
        end

        it 'csv_download_path' do

          month_stats = create(:stats_macroregian_investment, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          params = { stats_month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expected = "/files/downloads/integration/macroregions/#{year_month}/macroregions_#{year_month}.csv"

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

          expected = CacheHelper.cache_key_for(cache_key_prefix, Integration::Macroregions::MacroregionInvestiment)

          expect(controller.cache_key).to eq(expected)
        end

        it 'stats_cache_key' do
          month_stats = create(:stats_macroregian_investment, year: current_year)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          stats_year = "#{current_year}"

          params = { stats_year: stats_year }

          get :index, params: params

          # - # É importante considerar o xlsx_download_path no cache pois pode ter sido cacheado enquanto
          # - # gerava a planilha e, com o cache, nunca apareceria para o download.

          csv_download_path = controller.csv_download_path
          xlsx_download_path = controller.xlsx_download_path
          cache_prefix = "stats/macroregion_investiments/#{stats_year}/#{xlsx_download_path}/#{csv_download_path}"

          expected = CacheHelper.cache_key_for(cache_prefix, Stats::MacroregionInvestment)

          expect(controller.stats_cache_key).to eq(expected)
        end
      end
    end

    describe 'filters' do
      it 'by ano_exercicio' do
        current_year = create(:integration_macroregions_macroregion_investiment, ano_exercicio: Date.today.year)
        last_year = create(:integration_macroregions_macroregion_investiment, ano_exercicio: Date.today.year - 1)

        get(:index, params: { ano_exercicio: Date.today.year })

        expect(controller.macroregion_investiments).to eq([current_year])
      end

      it 'by descricao_poder' do
        executivo = create(:integration_macroregions_macroregion_investiment, descricao_poder: 'EXECUTIVO')
        legistativo = create(:integration_macroregions_macroregion_investiment, descricao_poder: 'LEGISLATIVO')

        get(:index, params: { descricao_poder: 'EXECUTIVO' })

        expect(controller.macroregion_investiments).to eq([executivo])
      end
    end

    describe 'pagination' do
      it 'calls kaminari methods' do
        allow(Integration::Macroregions::MacroregionInvestiment).to receive(:page).and_call_original
        expect(Integration::Macroregions::MacroregionInvestiment).to receive(:page).and_call_original

        get(:index)

        # para poder chamar o page que estamos testando
        controller.macroregion_investiments
      end
    end
  end
end
