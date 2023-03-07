# Shared example para action index de transparency/constructions/ders

shared_examples_for 'controllers/transparency/constructions/ders/index' do

  let(:current_year) { Date.today.year }
  let(:current_month) { Date.today.month }
  let(:der) { create(:integration_constructions_der) }

  describe '#index' do
    context 'template' do

      render_views

      before { get(:index) }

      it 'responds with success and renders templates' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/constructions/ders/index')
      end

      describe 'assets' do
        it 'javascript' do
          expected = 'views/shared/transparency/constructions/ders/index'
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
        allow(der.class).to receive(:page).and_call_original
        expect(der.class).to receive(:page).and_call_original
        controller.ders
      end
    end

    describe 'sort' do
      let(:first_unsorted) do
        create(:integration_constructions_der, id_obra: '123')
      end
      let(:last_unsorted) do
        create(:integration_constructions_der, id_obra: '456')
      end
      it 'default' do
        Integration::Constructions::Der.delete_all

        first_unsorted
        last_unsorted

        get(:index)

        expect(controller.ders).to eq([last_unsorted, first_unsorted])
      end

      it 'sort_column param' do
        get :index, params: { sort_column: 'integration_constructions_ders.id_obra' }

        scope = Integration::Constructions::Der.search_scope
        sorted = scope.sorted('integration_constructions_ders.id_obra', 'desc')
        paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
        expected = paginated.to_sql

        result = controller.ders.to_sql

        expect(result).to eq(expected)
      end

      it 'sort_direction param' do
        get :index, params: { sort_column: 'integration_constructions_ders.id_obra', sort_direction: :desc }

        scope = Integration::Constructions::Der.search_scope
        sorted = scope.order('integration_constructions_ders.id_obra desc')
        paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
        expected = paginated.to_sql

        result = controller.ders.to_sql

        expect(result).to eq(expected)
      end

      it 'sort_columns helper' do
        expected = [
          'integration_constructions_ders.status',
          'integration_constructions_ders.trecho',
          'integration_constructions_ders.construtora',
          'integration_constructions_ders.extensao',
          'integration_constructions_ders.valor_aprovado',
          'integration_constructions_ders.numero_contrato_sic'
        ]

        expect(controller.sort_columns).to eq(expected)
      end

      describe 'stats' do
        it 'stats' do
          month_stats = create(:stats_constructions_der, year: current_year, month: current_month)
          another_stats = create(:stats_constructions_der, year: current_year - 2, month: current_month)

          expect(controller.stats).to eq(month_stats)
          expect(controller.last_stats_month).to eq(Date.new(current_year, current_month))
        end

        it 'stats based on stats_month_year' do
          month_stats = create(:stats_constructions_der, year: current_year, month: current_month)
          another_stats = create(:stats_constructions_der, year: current_year - 2, month: current_month)

          params = { stats_month_year: "#{another_stats.month}/#{another_stats.year}" }
          get :index, params: params
          expect(controller.stats).to eq(another_stats)
        end
      end
    end

    describe 'helper methods' do
      it 'constructions' do
        expect(controller.ders).to eq([der])
      end

      it 'filtered_count' do
        der
        searched_der = create(:integration_constructions_der, id_obra: '987')

        get(:index, params: { search: '987' })

        expect(controller.filtered_count).to eq(1)
      end

      it 'filtered_sum' do
        der
        searched_der = create(:integration_constructions_der, id_obra: '987')

        get(:index, params: { search: '987' })

        expect(controller.filtered_sum).to eq(searched_der.valor_aprovado)
      end

      describe 'downloads' do
        it 'xlsx_download_path' do

          month_stats = create(:stats_constructions_der, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          params = { stats_month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expected = "/files/downloads/integration/constructions/ders/#{year_month}/ders_#{year_month}.xlsx"

          allow(File).to receive(:exists?).and_return(true)

          expect(controller.xlsx_download_path).to eq(expected)
        end

        it 'csv_download_path' do

          month_stats = create(:stats_constructions_der, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          params = { stats_month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expected = "/files/downloads/integration/constructions/ders/#{year_month}/ders_#{year_month}.csv"

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

          cache_key_prefix = "#{namespace}/#{params_digest}/#{Date.today.end_of_day}"

          expected = CacheHelper.cache_key_for(cache_key_prefix, Integration::Constructions::Der)

          expect(controller.cache_key).to eq(expected)
        end

        it 'stats_cache_key' do
          month_stats = create(:stats_constructions_der, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          stats_month_year = "#{current_month}/#{current_year}"

          params = { stats_month_year: stats_month_year }

          get :index, params: params

          # - # É importante considerar o xlsx_download_path no cache pois pode ter sido cacheado enquanto
          # - # gerava a planilha e, com o cache, nunca apareceria para o download.

          csv_download_path = controller.csv_download_path
          xlsx_download_path = controller.xlsx_download_path
          cache_prefix = "stats/constructions/ders/#{stats_month_year}/#{xlsx_download_path}/#{csv_download_path}/#{Date.today.end_of_day}"

          expected = CacheHelper.cache_key_for(cache_prefix, Stats::Constructions::Der)

          expect(controller.stats_cache_key).to eq(expected)
        end
      end
    end

    describe 'search' do
      it 'id_obra' do
        der
        searched_der = create(:integration_constructions_der, id_obra: '987')

        get(:index, params: { search: '987' })

        expect(controller.ders).to eq([searched_der])
      end

      # - # demais testes estão em ders/search_spec.rb
    end

    describe 'filters' do
      it 'by status' do
        in_progress = create(:integration_constructions_der, der_status: :in_progress)
        paused = create(:integration_constructions_der, der_status: :paused)

        get(:index, params: { der_status: :in_progress })

        expect(controller.ders).to eq([in_progress])

        get(:index, params: { der_status: :paused })

        expect(controller.ders).to eq([paused])
      end

      it 'by trecho' do
        trecho1 = create(:integration_constructions_der, trecho: 'T1')
        trecho2 = create(:integration_constructions_der, trecho: 'T2')

        get(:index, params: { trecho: 'T1' })

        expect(controller.ders).to eq([trecho1])

        get(:index, params: { trecho: 'T2' })

        expect(controller.ders).to eq([trecho2])
      end

      it 'by distrito' do
        distrito1 = create(:integration_constructions_der, distrito: 'T1')
        distrito2 = create(:integration_constructions_der, distrito: 'T2')

        get(:index, params: { distrito: 'T1' })

        expect(controller.ders).to eq([distrito1])

        get(:index, params: { distrito: 'T2' })

        expect(controller.ders).to eq([distrito2])
      end

      it 'by data_fim_contrato' do
        in_range = create(:integration_constructions_der, data_fim_contrato: Date.today)
        out_range = create(:integration_constructions_der, data_fim_contrato: Date.today - 10.month)

        range = "#{I18n.l(Date.today)} - #{I18n.l(Date.today + 1.month)}"

        get(:index, params: { data_fim_contrato: range })

        expect(controller.ders).to eq([in_range])
      end

      it 'by data_fim_previsto' do
        in_range = create(:integration_constructions_der, data_fim_previsto: Date.today)
        out_range = create(:integration_constructions_der, data_fim_previsto: Date.today - 10.month)

        range = "#{I18n.l(Date.today)} - #{I18n.l(Date.today + 1.month)}"

        get(:index, params: { data_fim_previsto: range })

        expect(controller.ders).to eq([in_range])
      end
    end

    describe 'pagination' do
      it 'calls kaminari methods' do
        allow(Integration::Constructions::Der).to receive(:page).and_call_original
        expect(Integration::Constructions::Der).to receive(:page).and_call_original

        get(:index)

        # para poder chamar o page que estamos testando
        controller.ders
      end
    end
  end
end
