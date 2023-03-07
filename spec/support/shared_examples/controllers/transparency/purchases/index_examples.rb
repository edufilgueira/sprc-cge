# Shared example para action index de transparency/purchases

shared_examples_for 'controllers/transparency/purchases/index' do

  let(:current_year) { Date.today.year }
  let(:current_month) { Date.today.month }
  let(:purchase) { create(:integration_purchases_purchase) }

  describe '#index' do
    context 'template' do

      render_views

      before { get(:index) }

      it 'responds with success and renders templates' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/purchases/index')
      end

      describe 'assets' do
        it 'javascript' do
          expected = 'views/shared/transparency/purchases/index'
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
        allow(purchase.class).to receive(:page).and_call_original
        expect(purchase.class).to receive(:page).and_call_original
        controller.purchases
      end
    end

    describe 'sort' do
      let(:first_unsorted) do
        create(:integration_purchases_purchase, numero_publicacao: '123')
      end
      let(:last_unsorted) do
        create(:integration_purchases_purchase, numero_publicacao: '456')
      end
      it 'default' do
        Integration::Purchases::Purchase.delete_all

        first_unsorted
        last_unsorted

        get(:index)

        expect(controller.purchases).to eq([last_unsorted, first_unsorted])
      end

      it 'sort_column param' do
        get :index, params: { sort_column: 'integration_purchases_purchases.numero_publicacao' }

        scope = Integration::Purchases::Purchase.search_scope
        sorted = scope.sorted('integration_purchases_purchases.numero_publicacao', 'desc')
        paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
        expected = paginated.to_sql

        result = controller.purchases.to_sql

        expect(result).to eq(expected)
      end

      it 'sort_direction param' do
        get :index, params: { sort_column: 'integration_purchases_purchases.numero_publicacao', sort_direction: :desc }

        scope = Integration::Purchases::Purchase.search_scope
        sorted = scope.order('integration_purchases_purchases.numero_publicacao desc')
        paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
        expected = paginated.to_sql

        result = controller.purchases.to_sql

        expect(result).to eq(expected)
      end

      it 'sort_columns helper' do
        expected = %w[
          integration_purchases_purchases.numero_publicacao
          integration_purchases_purchases.nome_fornecedor
          integration_purchases_purchases.nome_resp_compra
          integration_purchases_purchases.codigo_item
          integration_purchases_purchases.descricao_item
          integration_purchases_purchases.quantidade_estimada
          integration_purchases_purchases.valor_total_calculated
        ]

        expect(controller.sort_columns).to eq(expected)
      end

      describe 'stats' do
        it 'stats' do
          month_stats = create(:stats_purchase, year: current_year, month: current_month)
          another_stats = create(:stats_purchase, year: current_year - 2, month: current_month)

          expect(controller.stats).to eq(month_stats)
          expect(controller.last_stats_month).to eq(Date.new(current_year, current_month))
        end

        it 'stats based on stats_month_year' do
          month_stats = create(:stats_purchase, year: current_year, month: current_month)
          another_stats = create(:stats_purchase, year: current_year - 2, month: current_month)

          params = { stats_month_year: "#{another_stats.month}/#{another_stats.year}" }
          get :index, params: params
          expect(controller.stats).to eq(another_stats)
        end
      end
    end

    describe 'helper methods' do
      it 'purchases' do
        expect(controller.purchases).to eq([purchase])
      end

      it 'filtered_count' do
        purchase
        searched_purchase = create(:integration_purchases_purchase, codigo_item: '987')

        get(:index, params: { search: '987' })

        expect(controller.filtered_count).to eq(1)
      end

      it 'filtered_sum' do
        purchase
        searched_purchase = create(:integration_purchases_purchase, codigo_item: '987')

        get(:index, params: { search: '987' })

        expect(controller.filtered_sum).to eq(searched_purchase.valor_total_calculated.to_f)
      end

      describe 'downloads' do
        it 'xlsx_download_path' do

          month_stats = create(:stats_purchase, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          params = { stats_month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expected = "/files/downloads/integration/purchases/#{year_month}/compras_#{year_month}.xlsx"

          allow(File).to receive(:exists?).and_return(true)

          expect(controller.xlsx_download_path).to eq(expected)
        end

        it 'csv_download_path' do

          month_stats = create(:stats_purchase, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          params = { stats_month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expected = "/files/downloads/integration/purchases/#{year_month}/compras_#{year_month}.csv"

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

          expected = CacheHelper.cache_key_for(cache_key_prefix, Integration::Purchases::Purchase)

          expect(controller.cache_key).to eq(expected)
        end

        it 'stats_cache_key' do
          month_stats = create(:stats_purchase, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          stats_month_year = "#{current_month}/#{current_year}"

          params = { stats_month_year: stats_month_year }

          get :index, params: params

          # - # É importante considerar o xlsx_download_path no cache pois pode ter sido cacheado enquanto
          # - # gerava a planilha e, com o cache, nunca apareceria para o download.

          csv_download_path = controller.csv_download_path
          xlsx_download_path = controller.xlsx_download_path
          cache_prefix = "stats/purchases/#{stats_month_year}/#{xlsx_download_path}/#{csv_download_path}"

          expected = CacheHelper.cache_key_for(cache_prefix, Stats::Purchase)

          expect(controller.stats_cache_key).to eq(expected)
        end
      end
    end

    describe 'filters' do
      it 'by manager' do
        organ = create(:integration_supports_management_unit)
        filtered_purchase = create(:integration_purchases_purchase, manager: organ)
        purchase

        get(:index, params: { manager_id: organ.id })

        expect(controller.purchases).to eq([filtered_purchase])

      end

      it 'by data_publicacao' do
        in_range = create(:integration_purchases_purchase, data_publicacao: Date.today)
        out_range = create(:integration_purchases_purchase, data_publicacao: Date.today - 10.month)

        range = "#{I18n.l(Date.today)} - #{I18n.l(Date.today + 1.month)}"

        get(:index, params: { data_publicacao: range })

        expect(controller.purchases).to eq([in_range])
      end

      it 'by data_finalizada' do
        in_range = create(:integration_purchases_purchase, data_finalizada: Date.today)
        out_range = create(:integration_purchases_purchase, data_finalizada: Date.today - 10.month)

        range = "#{I18n.l(Date.today)} - #{I18n.l(Date.today + 1.month)}"

        get(:index, params: { data_finalizada: range })

        expect(controller.purchases).to eq([in_range])
      end

      it 'by sistematica_aquisicao' do
        in_range = create(:integration_purchases_purchase, sistematica_aquisicao: 'sistematica_aquisicao')
        out_range = create(:integration_purchases_purchase, sistematica_aquisicao: 'out_range')

        get(:index, params: { sistematica_aquisicao: in_range.sistematica_aquisicao })

        expect(controller.purchases).to eq([in_range])
      end

      it 'by forma_aquisicao' do
        in_range = create(:integration_purchases_purchase, forma_aquisicao: 'forma_aquisicao')
        out_range = create(:integration_purchases_purchase, forma_aquisicao: 'out_range')

        get(:index, params: { forma_aquisicao: in_range.forma_aquisicao })

        expect(controller.purchases).to eq([in_range])
      end

      it 'by natureza_aquisicao' do
        in_range = create(:integration_purchases_purchase, natureza_aquisicao: 'natureza_aquisicao')
        out_range = create(:integration_purchases_purchase, natureza_aquisicao: 'out_range')

        get(:index, params: { natureza_aquisicao: in_range.natureza_aquisicao })

        expect(controller.purchases).to eq([in_range])
      end

      it 'by tipo_aquisicao' do
        in_range = create(:integration_purchases_purchase, tipo_aquisicao: 'tipo_aquisicao')
        out_range = create(:integration_purchases_purchase, tipo_aquisicao: 'out_range')

        get(:index, params: { tipo_aquisicao: in_range.tipo_aquisicao })

        expect(controller.purchases).to eq([in_range])
      end

      it 'by nome_fornecedor' do
        in_range = create(:integration_purchases_purchase, nome_fornecedor: 'nome_fornecedor')
        out_range = create(:integration_purchases_purchase, nome_fornecedor: 'out_range')

        get(:index, params: { nome_fornecedor: in_range.nome_fornecedor })

        expect(controller.purchases).to eq([in_range])
      end
    end

    describe 'pagination' do
      it 'calls kaminari methods' do
        allow(Integration::Purchases::Purchase).to receive(:page).and_call_original
        expect(Integration::Purchases::Purchase).to receive(:page).and_call_original

        get(:index)

        # para poder chamar o page que estamos testando
        controller.purchases
      end
    end
  end
end
