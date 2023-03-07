# Shared example para action index de transparency/real_states

shared_examples_for 'controllers/transparency/real_states/index' do

  let(:current_year) { Date.today.year }
  let(:current_month) { Date.today.month }
  let(:real_state) { create(:integration_real_states_real_state) }

  describe '#index' do
    context 'template' do

      render_views

      before { get(:index) }

      it 'responds with success and renders templates' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/real_states/index')
      end

      describe 'assets' do
        it 'javascript' do
          expected = 'views/shared/transparency/real_states/index'
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
        allow(real_state.class).to receive(:page).and_call_original
        expect(real_state.class).to receive(:page).and_call_original
        controller.real_states
      end
    end

    describe 'sort' do
      let(:first_unsorted) do
        create(:integration_real_states_real_state, id: 123)
      end
      let(:last_unsorted) do
        create(:integration_real_states_real_state, id: 456)
      end
      it 'default' do
        Integration::RealStates::RealState.delete_all

        first_unsorted
        last_unsorted

        get(:index)

        expect(controller.real_states).to eq([first_unsorted, last_unsorted])
      end

      it 'sort_column param' do
        get :index, params: { sort_column: 'integration_real_states_real_states.id' }

        scope = Integration::RealStates::RealState.search_scope
        sorted = scope.sorted('integration_real_states_real_states.id', 'asc')
        paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
        expected = paginated.eager_load(:manager, :property_type, :occupation_type).to_sql

        result = controller.real_states.to_sql

        expect(result).to eq(expected)
      end

      it 'sort_direction param' do
        get :index, params: { sort_column: 'integration_real_states_real_states.id', sort_direction: :asc }

        scope = Integration::RealStates::RealState.search_scope
        sorted = scope.order('integration_real_states_real_states.id asc')
        paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
        expected = paginated.eager_load(:manager, :property_type, :occupation_type).to_sql

        result = controller.real_states.to_sql

        expect(result).to eq(expected)
      end

      it 'sort_columns helper' do
        expected = %w[
          integration_real_states_real_states.id
          integration_real_states_real_states.descricao_imovel
          integration_supports_organs.sigla
          integration_supports_real_states_property_types.title
          integration_supports_real_states_occupation_types.title
          integration_real_states_real_states.municipio
        ]

        expect(controller.sort_columns).to eq(expected)
      end

      describe 'stats' do
        it 'stats' do
          month_stats = create(:stats_real_state, year: current_year, month: current_month)
          another_stats = create(:stats_real_state, year: current_year - 2, month: current_month)

          expect(controller.stats).to eq(month_stats)
          expect(controller.last_stats_month).to eq(Date.new(current_year, current_month))
        end

        it 'stats based on stats_month_year' do
          month_stats = create(:stats_real_state, year: current_year, month: current_month)
          another_stats = create(:stats_real_state, year: current_year - 2, month: current_month)

          params = { stats_month_year: "#{another_stats.month}/#{another_stats.year}" }
          get :index, params: params
          expect(controller.stats).to eq(another_stats)
        end
      end
    end

    describe 'helper methods' do
      it 'real_states' do
        expect(controller.real_states).to eq([real_state])
      end

      it 'filtered_count' do
        real_state
        searched_real_state = create(:integration_real_states_real_state, numero_imovel: '987')

        get(:index, params: { search: '987' })

        expect(controller.filtered_count).to eq(1)
      end

      it 'filtered_sum' do
        real_state
        searched_real_state = create(:integration_real_states_real_state, numero_imovel: '987')

        get(:index, params: { search: '987' })

        expect(controller.filtered_sum).to eq(searched_real_state.area_projecao_construcao)
      end

      describe 'downloads' do
        it 'xlsx_download_path' do

          month_stats = create(:stats_real_state, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          params = { stats_month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expected = "/files/downloads/integration/real_states/#{year_month}/bens_imoveis_#{year_month}.xlsx"

          allow(File).to receive(:exists?).and_return(true)

          expect(controller.xlsx_download_path).to eq(expected)
        end

        it 'csv_download_path' do

          month_stats = create(:stats_real_state, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          params = { stats_month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expected = "/files/downloads/integration/real_states/#{year_month}/bens_imoveis_#{year_month}.csv"

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

          expected = CacheHelper.cache_key_for(cache_key_prefix, Integration::RealStates::RealState)

          expect(controller.cache_key).to eq(expected)
        end

        it 'stats_cache_key' do
          month_stats = create(:stats_real_state, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          stats_month_year = "#{current_month}/#{current_year}"

          params = { stats_month_year: stats_month_year }

          get :index, params: params

          # - # É importante considerar o xlsx_download_path no cache pois pode ter sido cacheado enquanto
          # - # gerava a planilha e, com o cache, nunca apareceria para o download.

          csv_download_path = controller.csv_download_path
          xlsx_download_path = controller.xlsx_download_path
          cache_prefix = "stats/real_states/#{stats_month_year}/#{xlsx_download_path}/#{csv_download_path}"

          expected = CacheHelper.cache_key_for(cache_prefix, Stats::RealState)

          expect(controller.stats_cache_key).to eq(expected)
        end
      end
    end

    describe 'filters' do
      it 'by manager' do
        organ = create(:integration_supports_organ)
        filtered_real_state = create(:integration_real_states_real_state, manager: organ)
        real_state

        get(:index, params: { manager_id: organ.id })

        expect(controller.real_states).to eq([filtered_real_state])

      end

      it 'by property_type' do
        property_type = create(:integration_supports_real_states_property_type)
        filtered_real_state = create(:integration_real_states_real_state, property_type: property_type)
        real_state

        get(:index, params: { property_type_id: property_type.id })

        expect(controller.real_states).to eq([filtered_real_state])
      end

      it 'by occupation_type' do
        occupation_type = create(:integration_supports_real_states_occupation_type)
        filtered_real_state = create(:integration_real_states_real_state, occupation_type: occupation_type)
        real_state

        get(:index, params: { occupation_type_id: occupation_type.id })

        expect(controller.real_states).to eq([filtered_real_state])
      end

      it 'by municipio' do
        municipio = 'MUNICIPIO CAMPINAS1'
        filtered_real_state = create(:integration_real_states_real_state, municipio: municipio)
        real_state

        get(:index, params: { municipio: municipio })

        expect(controller.real_states).to eq([filtered_real_state])
      end

      it 'by bairro' do
        bairro = 'BAIRRO CAMPINAS1'
        filtered_real_state = create(:integration_real_states_real_state, bairro: bairro)
        real_state

        get(:index, params: { bairro: bairro })

        expect(controller.real_states).to eq([filtered_real_state])
      end
    end

    describe 'pagination' do
      it 'calls kaminari methods' do
        allow(Integration::RealStates::RealState).to receive(:page).and_call_original
        expect(Integration::RealStates::RealState).to receive(:page).and_call_original

        get(:index)

        # para poder chamar o page que estamos testando
        controller.real_states
      end
    end
  end
end
