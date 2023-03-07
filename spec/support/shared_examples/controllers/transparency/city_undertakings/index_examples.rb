# Shared example para action index de transparency/city_undertakings

shared_examples_for 'controllers/transparency/city_undertakings/index' do

  let(:current_year) { Date.today.year }
  let(:current_month) { Date.today.month }
  let(:contract) { create(:integration_contracts_contract) }
  let(:city_undertaking) { create(:integration_city_undertakings_city_undertaking, sic: contract.isn_sic) }

  describe '#index' do
    context 'template' do

      render_views

      before { get(:index) }

      it 'responds with success and renders templates' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/city_undertakings/index')
      end

      describe 'assets' do
        it 'javascript' do
          expected = 'views/shared/transparency/city_undertakings/index'
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
        allow(city_undertaking.class).to receive(:page).and_call_original
        expect(city_undertaking.class).to receive(:page).and_call_original
        controller.city_undertakings
      end
    end

    describe 'sort' do
      let(:first_contract) { create(:integration_contracts_contract, isn_sic: 1) }
      let(:last_contract) { create(:integration_contracts_contract, isn_sic: 2) }

      let(:first_unsorted) do
        create(:integration_city_undertakings_city_undertaking, sic: first_contract.isn_sic)
      end

      let(:last_unsorted) do
        create(:integration_city_undertakings_city_undertaking, sic: last_contract.isn_sic)
      end

      it 'default' do
        Integration::CityUndertakings::CityUndertaking.delete_all

        first_unsorted
        last_unsorted

        get(:index)

        expect(controller.city_undertakings).to eq([first_unsorted, last_unsorted])
      end

      it 'sort_column param' do
        get :index, params: { sort_column: 'integration_contracts_contracts.data_assinatura' }

        scope = Integration::CityUndertakings::CityUndertaking.search_scope
        sorted = scope.sorted('integration_contracts_contracts.data_assinatura', 'desc')
        paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
        expected = paginated.eager_load(:organ, :creditor, :undertaking).to_sql

        result = controller.city_undertakings.to_sql

        expect(result).to eq(expected)
      end

      it 'sort_direction param' do
        get :index, params: { sort_column: 'integration_contracts_contracts.data_assinatura', sort_direction: :asc }

        scope = Integration::CityUndertakings::CityUndertaking.search_scope
        sorted = scope.order('integration_contracts_contracts.data_assinatura asc')
        paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
        expected = paginated.eager_load(:organ, :creditor, :undertaking).to_sql

        result = controller.city_undertakings.to_sql

        expect(result).to eq(expected)
      end

      it 'sort_columns helper' do
        expected = {
          data_assinatura: 'integration_contracts_contracts.data_assinatura',
          sic: 'integration_city_undertakings_city_undertakings.sic',
          municipio: 'integration_city_undertakings_city_undertakings.municipio',
          sigla: 'integration_supports_organs.sigla',
          descricao: 'integration_supports_undertakings.descricao',
          mapp: 'integration_city_undertakings_city_undertakings.mapp'
        }

        expect(controller.sort_columns).to eq(expected)
      end

      describe 'stats' do
        it 'stats' do
          month_stats = create(:stats_city_undertaking, year: current_year, month: current_month)
          another_stats = create(:stats_city_undertaking, year: current_year - 2, month: current_month)

          expect(controller.stats).to eq(month_stats)
          expect(controller.last_stats_month).to eq(Date.new(current_year, current_month))
        end

        it 'stats based on stats_month_year' do
          month_stats = create(:stats_city_undertaking, year: current_year, month: current_month)
          another_stats = create(:stats_city_undertaking, year: current_year - 2, month: current_month)

          params = { stats_month_year: "#{another_stats.month}/#{another_stats.year}" }
          get :index, params: params
          expect(controller.stats).to eq(another_stats)
        end
      end
    end

    describe 'helper methods' do
      let(:contract) { create(:integration_contracts_contract, isn_sic: 1) }

      it 'city_undertakings' do
        expect(controller.city_undertakings).to eq([city_undertaking])
      end

      it 'filtered_count' do
        city_undertaking
        searched_city_undertaking = create(:integration_city_undertakings_city_undertaking, municipio: '987', sic: contract.isn_sic)

        get(:index, params: { search: '987' })

        expect(controller.filtered_count).to eq(1)
      end

      it 'filtered_sum' do
        city_undertaking
        searched_city_undertaking = create(:integration_city_undertakings_city_undertaking, municipio: '987', sic: contract.isn_sic)
        filtered_sum = (1..8).inject(0) { |t, i| t += searched_city_undertaking.send("valor_executado#{i}"); t }

        get(:index, params: { search: '987' })

        expect(controller.filtered_sum).to eq(filtered_sum)
      end

      describe 'downloads' do
        it 'xlsx_download_path' do

          month_stats = create(:stats_city_undertaking, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          params = { stats_month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expected = "/files/downloads/integration/city_undertakings/#{year_month}/empreendimentos_municipios_#{year_month}.xlsx"

          allow(File).to receive(:exists?).and_return(true)

          expect(controller.xlsx_download_path).to eq(expected)
        end

        it 'csv_download_path' do

          month_stats = create(:stats_city_undertaking, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          params = { stats_month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expected = "/files/downloads/integration/city_undertakings/#{year_month}/empreendimentos_municipios_#{year_month}.csv"

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

          expected = CacheHelper.cache_key_for(cache_key_prefix, Integration::CityUndertakings::CityUndertaking)

          expect(controller.cache_key).to eq(expected)
        end

        it 'stats_cache_key' do
          month_stats = create(:stats_city_undertaking, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          stats_month_year = "#{current_month}/#{current_year}"

          params = { stats_month_year: stats_month_year }

          get :index, params: params

          # - # É importante considerar o xlsx_download_path no cache pois pode ter sido cacheado enquanto
          # - # gerava a planilha e, com o cache, nunca apareceria para o download.

          csv_download_path = controller.csv_download_path
          xlsx_download_path = controller.xlsx_download_path
          cache_prefix = "stats/city_undertakings/#{stats_month_year}/#{xlsx_download_path}/#{csv_download_path}"

          expected = CacheHelper.cache_key_for(cache_prefix, Stats::CityUndertaking)

          expect(controller.stats_cache_key).to eq(expected)
        end
      end
    end

    describe 'filters' do
      it 'by organ' do
        organ = create(:integration_supports_organ)
        filtered_city_undertaking = create(:integration_city_undertakings_city_undertaking, organ: organ, sic: contract.isn_sic)
        city_undertaking

        get(:index, params: { organ_id: organ.id })

        expect(controller.city_undertakings).to eq([filtered_city_undertaking])

      end

      it 'by creditor' do
        creditor = create(:integration_supports_creditor)
        filtered_city_undertaking = create(:integration_city_undertakings_city_undertaking, creditor: creditor, sic: contract.isn_sic)
        city_undertaking

        get(:index, params: { creditor_id: creditor.id })

        expect(controller.city_undertakings).to eq([filtered_city_undertaking])
      end

      it 'by undertaking' do
        undertaking = create(:integration_supports_undertaking)
        filtered_city_undertaking = create(:integration_city_undertakings_city_undertaking, undertaking: undertaking, sic: contract.isn_sic)
        city_undertaking

        get(:index, params: { undertaking_id: undertaking.id })

        expect(controller.city_undertakings).to eq([filtered_city_undertaking])
      end

      it 'by municipio' do
        municipio = 'MUNICIPIO CAMPINAS1'
        filtered_city_undertaking = create(:integration_city_undertakings_city_undertaking, municipio: municipio, sic: contract.isn_sic)
        city_undertaking

        get(:index, params: { municipio: municipio })

        expect(controller.city_undertakings).to eq([filtered_city_undertaking])
      end

      it 'by mapp' do
        mapp = 'PROJETO CAMPINAS1'
        filtered_city_undertaking = create(:integration_city_undertakings_city_undertaking, mapp: mapp, sic: contract.isn_sic)
        city_undertaking

        get(:index, params: { mapp: mapp })

        expect(controller.city_undertakings).to eq([filtered_city_undertaking])
      end

      it 'by expense' do
        expense = 'contract'
        filtered_city_undertaking = create(:integration_city_undertakings_city_undertaking, expense: expense, sic: contract.isn_sic)
        city_undertaking

        get(:index, params: { expense: expense })

        expect(controller.city_undertakings).to eq([filtered_city_undertaking])
      end
    end

     describe 'search_datalist' do
      it 'credor' do
        creditor = create(:integration_supports_creditor, nome: 'CAIENA')
        filtered_city_undertaking = create(:integration_city_undertakings_city_undertaking, creditor: creditor, sic: contract.isn_sic)
        city_undertaking

        get(:index, params: { search_datalist: creditor.nome })

        expect(controller.city_undertakings).to eq([filtered_city_undertaking])
      end
    end

    describe 'pagination' do
      it 'calls kaminari methods' do
        allow(Integration::CityUndertakings::CityUndertaking).to receive(:page).and_call_original
        expect(Integration::CityUndertakings::CityUndertaking).to receive(:page).and_call_original

        get(:index)

        # para poder chamar o page que estamos testando
        controller.city_undertakings
      end
    end
  end
end
