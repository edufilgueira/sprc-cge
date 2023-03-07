# Shared example para action index de transparency/constructions/daes

shared_examples_for 'controllers/transparency/constructions/daes/index' do

  let(:current_year) { Date.today.year }
  let(:current_month) { Date.today.month }
  let(:dae) { create(:integration_constructions_dae) }

  describe '#index' do
    context 'template' do

      render_views

      before { get(:index) }

      it 'responds with success and renders templates' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/constructions/daes/index')
      end

      describe 'assets' do
        it 'javascript' do
          expected = 'views/shared/transparency/constructions/daes/index'
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
        allow(dae.class).to receive(:page).and_call_original
        expect(dae.class).to receive(:page).and_call_original
        controller.daes
      end
    end

    describe 'sort' do
      let(:first_unsorted) do
        create(:integration_constructions_dae, id_obra: '123')
      end
      let(:last_unsorted) do
        create(:integration_constructions_dae, id_obra: '456')
      end
      it 'default' do
        Integration::Contracts::Contract.delete_all

        first_unsorted
        last_unsorted

        get(:index)

        expect(controller.daes).to eq([last_unsorted, first_unsorted])
      end

      it 'sort_column param' do
        get :index, params: { sort_column: 'integration_constructions_daes.id_obra' }

        scope = Integration::Constructions::Dae.search_scope
        sorted = scope.sorted('integration_constructions_daes.id_obra', 'desc')
        paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
        expected = paginated.to_sql

        result = controller.daes.to_sql

        expect(result).to eq(expected)
      end

      it 'sort_direction param' do
        get :index, params: { sort_column: 'integration_constructions_daes.id_obra', sort_direction: :desc }

        scope = Integration::Constructions::Dae.search_scope
        sorted = scope.order('integration_constructions_daes.id_obra desc')
        paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
        expected = paginated.to_sql

        result = controller.daes.to_sql

        expect(result).to eq(expected)
      end

      it 'sort_columns helper' do
        expected = [
          'integration_constructions_daes.numero_sacc',
          'integration_constructions_daes.secretaria',
          'integration_constructions_daes.contratada',
          'integration_constructions_daes.descricao',
          'integration_constructions_daes.municipio',
          'integration_constructions_daes.status',
          'integration_constructions_daes.valor'
        ]

        expect(controller.sort_columns).to eq(expected)
      end

      describe 'stats' do
        it 'stats' do
          month_stats = create(:stats_constructions_dae, year: current_year, month: current_month)
          another_stats = create(:stats_constructions_dae, year: current_year - 2, month: current_month)

          expect(controller.stats).to eq(month_stats)
          expect(controller.last_stats_month).to eq(Date.new(current_year, current_month))
        end

        it 'stats based on stats_month_year' do
          month_stats = create(:stats_constructions_dae, year: current_year, month: current_month)
          another_stats = create(:stats_constructions_dae, year: current_year - 2, month: current_month)

          params = { stats_month_year: "#{another_stats.month}/#{another_stats.year}" }
          get :index, params: params
          expect(controller.stats).to eq(another_stats)
        end
      end
    end

    describe 'helper methods' do

      it 'constructions' do
        expect(controller.daes).to eq([dae])
      end

      it 'filtered_count' do
        dae
        searched_dae = create(:integration_constructions_dae, id_obra: '987')

        get(:index, params: { search: '987' })

        expect(controller.filtered_count).to eq(1)
      end

      it 'filtered_sum' do
        dae
        searched_dae = create(:integration_constructions_dae, id_obra: '987')

        get(:index, params: { search: '987' })

        expect(controller.filtered_sum).to eq(searched_dae.valor)
      end

      describe 'downloads' do
        it 'xlsx_download_path' do

          month_stats = create(:stats_constructions_dae, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          params = { stats_month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expected = "/files/downloads/integration/constructions/daes/#{year_month}/daes_#{year_month}.xlsx"

          allow(File).to receive(:exists?).and_return(true)

          expect(controller.xlsx_download_path).to eq(expected)
        end

        it 'csv_download_path' do

          month_stats = create(:stats_constructions_dae, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          params = { stats_month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expected = "/files/downloads/integration/constructions/daes/#{year_month}/daes_#{year_month}.csv"

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

          expected = CacheHelper.cache_key_for(cache_key_prefix, Integration::Constructions::Dae)

          expect(controller.cache_key).to eq(expected)
        end

        it 'stats_cache_key' do
          month_stats = create(:stats_constructions_dae, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          stats_month_year = "#{current_month}/#{current_year}"

          params = { stats_month_year: stats_month_year }

          get :index, params: params

          # - # É importante considerar o xlsx_download_path no cache pois pode ter sido cacheado enquanto
          # - # gerava a planilha e, com o cache, nunca apareceria para o download.

          csv_download_path = controller.csv_download_path
          xlsx_download_path = controller.xlsx_download_path
          cache_prefix = "stats/constructions/daes/#{stats_month_year}/#{xlsx_download_path}/#{csv_download_path}/#{Date.today.end_of_day}"

          expected = CacheHelper.cache_key_for(cache_prefix, Stats::Constructions::Dae)

          expect(controller.stats_cache_key).to eq(expected)
        end
      end
    end

    describe 'search' do
      it 'id_obra' do
        dae
        searched_dae = create(:integration_constructions_dae, id_obra: '987')

        get(:index, params: { search: '987' })

        expect(controller.daes).to eq([searched_dae])
      end

      # - # demais testes estão em daes/search_spec.rb
    end

    describe 'filters' do
      it 'by status' do
        in_progress = create(:integration_constructions_dae, dae_status: :in_progress)
        paused = create(:integration_constructions_dae, dae_status: :paused)

        get(:index, params: { dae_status: :in_progress })

        expect(controller.daes).to eq([in_progress])

        get(:index, params: { dae_status: :paused })

        expect(controller.daes).to eq([paused])
      end

      it 'by data_inicio' do
        in_range = create(:integration_constructions_dae, data_inicio: Date.today)
        out_range = create(:integration_constructions_dae, data_inicio: Date.today - 10.month)

        range = "#{I18n.l(Date.today)} - #{I18n.l(Date.today + 1.month)}"

        get(:index, params: { data_inicio: range })

        expect(controller.daes).to eq([in_range])
      end

      it 'by data_fim_previsto' do
        in_range = create(:integration_constructions_dae, data_fim_previsto: Date.today)
        out_range = create(:integration_constructions_dae, data_fim_previsto: Date.today - 10.month)

        range = "#{I18n.l(Date.today)} - #{I18n.l(Date.today + 1.month)}"

        get(:index, params: { data_fim_previsto: range })

        expect(controller.daes).to eq([in_range])
      end

      it 'by organ' do
        support_organ = create(:integration_supports_organ, :secretary)
        dae_with_organ = create(:integration_constructions_dae, organ: support_organ)
        dae

        get(:index, params: { organ_id: support_organ })

        expect(controller.daes).to eq([dae_with_organ])
      end

      it 'by municipio' do
        municipio = 'MUNICIPIO XXX'
        dae_with_municipio = create(:integration_constructions_dae, municipio: municipio)
        dae

        get(:index, params: { municipio: municipio })

        expect(controller.daes).to eq([dae_with_municipio])
      end
    end

    describe 'pagination' do
      it 'calls kaminari methods' do
        allow(Integration::Constructions::Dae).to receive(:page).and_call_original
        expect(Integration::Constructions::Dae).to receive(:page).and_call_original

        get(:index)

        # para poder chamar o page que estamos testando
        controller.daes
      end
    end
  end
end
