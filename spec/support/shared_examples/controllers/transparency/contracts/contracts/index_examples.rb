# Shared example para action index de transparency/contracts/contracts

shared_examples_for 'controllers/transparency/contracts/contracts/index' do

  let(:current_year) { Date.today.year }
  let(:current_month) { Date.today.month }

  let(:contract) { create(:integration_contracts_contract, :with_nesteds) }

  describe '#index' do
    context 'template' do

      render_views

      before { get(:index) }

      it 'responds with success and renders templates' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/contracts/contracts/index')
      end

      describe 'assets' do
        it 'javascript' do
          expected = 'views/shared/transparency/contracts/contracts/index'
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
        allow(contract.class).to receive(:page).and_call_original
        expect(contract.class).to receive(:page).and_call_original
        controller.contracts
      end
    end

    describe 'sort' do
      let(:first_unsorted) do
        create(:integration_contracts_contract, data_assinatura: '01/01/2001')
      end
      let(:last_unsorted) do
        create(:integration_contracts_contract, data_assinatura: '01/01/2011')
      end
      it 'default' do
        Integration::Contracts::Contract.delete_all

        first_unsorted
        last_unsorted

        get(:index)

        expect(controller.contracts).to eq([last_unsorted, first_unsorted])
      end

      it 'sort_column param' do
        get :index, params: { sort_column: 'integration_contracts_contracts.data_assinatura' }

        from_type = Integration::Contracts::Contract.search_scope
        join = from_type.includes(:manager, :grantor).references(:manager)
        sorted = join.sorted('integration_contracts_contracts.data_assinatura', 'desc')
        paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
        expected = paginated.to_sql

        result = controller.contracts.to_sql

        expect(result).to eq(expected)
      end

      it 'sort_direction param' do
        get :index, params: { sort_column: 'integration_contracts_contracts.data_assinatura', sort_direction: :asc }

        from_type = Integration::Contracts::Contract.search_scope
        join = from_type.includes(:manager, :grantor).references(:manager)
        sorted = join.order('integration_contracts_contracts.data_assinatura asc')
        paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
        expected = paginated.to_sql

        result = controller.contracts.to_sql

        expect(result).to eq(expected)
      end

      it 'sort_columns helper' do
        expected = [
          'integration_contracts_contracts.data_assinatura',
          'integration_contracts_contracts.isn_sic',
          'integration_contracts_contracts.num_contrato',
          'integration_supports_organs.descricao_orgao',
          'integration_supports_management_units.titulo',
          'integration_contracts_contracts.descricao_nome_credor',
          'integration_contracts_contracts.descricao_objeto',
          'integration_contracts_contracts.valor_atualizado_concedente',
          'integration_contracts_contracts.calculated_valor_empenhado',
          'integration_contracts_contracts.calculated_valor_pago'
        ]

        expect(controller.sort_columns).to eq(expected)
      end

      describe 'stats' do
        it 'stats' do
          month_stats = create(:stats_contracts_contract, year: current_year, month: current_month)
          another_stats = create(:stats_contracts_contract, year: current_year - 2, month: current_month)

          expect(controller.stats).to eq(month_stats)
          expect(controller.last_stats_month).to eq(Date.new(current_year, current_month))
        end

        it 'stats based on stats_month_year' do
          month_stats = create(:stats_contracts_contract, year: current_year, month: current_month)
          another_stats = create(:stats_contracts_contract, year: current_year - 2, month: current_month)

          params = { stats_month_year: "#{another_stats.month}/#{another_stats.year}" }
          get :index, params: params
          expect(controller.stats).to eq(another_stats)
        end
      end
    end

    describe 'helper methods' do
      it 'contracts' do
        expect(controller.contracts).to eq([contract])
      end

      it 'filtered_count' do
        contract
        searched_contract = create(:integration_contracts_contract, isn_sic: '987')

        get(:index, params: { search: '987' })

        expect(controller.filtered_count).to eq(1)
      end

      it 'filtered_sum' do
        contract
        searched_contract = create(:integration_contracts_contract, isn_sic: '987', valor_atualizado_concedente: 100)

        get(:index, params: { search: '987' })

        expect(controller.filtered_sum).to eq(searched_contract.valor_atualizado_concedente)
      end

      describe 'downloads' do
        it 'xlsx_download_path' do

          month_stats = create(:stats_contracts_contract, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          params = { stats_month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expected = "/files/downloads/integration/contracts/contracts/#{year_month}/contratos_#{year_month}.xlsx"

          allow(File).to receive(:exists?).and_return(true)

          expect(controller.xlsx_download_path).to eq(expected)
        end

        it 'csv_download_path' do

          month_stats = create(:stats_contracts_contract, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          params = { stats_month_year: "#{current_month}/#{current_year}" }

          get :index, params: params

          expected = "/files/downloads/integration/contracts/contracts/#{year_month}/contratos_#{year_month}.csv"

          allow(File).to receive(:exists?).and_return(true)

          expect(controller.csv_download_path).to eq(expected)
        end
      end

      describe 'cache' do
        it 'cache_key' do
          # ?? importante que a chave do cache considere TODOS os par??metros que possam
          # alterar a view: page, sort_column, ...,. Al??m dos par??metros do pr??prio
          # model.

          get :index, params: { search: '123' }

          allow(Digest::SHA256).to receive(:hexdigest).and_return('abcde')

          cache_params = controller.params.permit!.to_h.to_s
          params_digest = Digest::SHA256.hexdigest(cache_params)

          # ?? importante usar o namespace no cache pois os links para show_path
          # das ferramentas de transpar??ncia que s??o compartilhadas por diversos
          # namespaces (:admin, :platform, ...) deve ser espec??ficos.

          namespace = controller.namespace

          cache_key_prefix = "#{namespace}/#{params_digest}/#{Date.today.end_of_day}"


          expected = CacheHelper.cache_key_for(cache_key_prefix, Integration::Contracts::Contract)

          expect(controller.cache_key).to eq(expected)
        end

        it 'stats_cache_key' do
          month_stats = create(:stats_contracts_contract, year: current_year, month: current_month)

          date = Date.new(current_year, current_month)
          year_month = I18n.l(date, format: "%Y%m")

          stats_month_year = "#{current_month}/#{current_year}"

          params = { stats_month_year: stats_month_year }

          get :index, params: params

          # - # ?? importante considerar o xlsx_download_path no cache pois pode ter sido cacheado enquanto
          # - # gerava a planilha e, com o cache, nunca apareceria para o download.

          csv_download_path = controller.csv_download_path
          xlsx_download_path = controller.xlsx_download_path
          cache_prefix = "stats/contracts/contracts/#{stats_month_year}/#{xlsx_download_path}/#{csv_download_path}/#{Date.today.end_of_day}"

          expected = CacheHelper.cache_key_for(cache_prefix, Stats::Contracts::Contract)

          expect(controller.stats_cache_key).to eq(expected)
        end
      end
    end

    describe 'search' do
      it 'contrato' do
        contract
        searched_contract = create(:integration_contracts_contract, isn_sic: '987')

        get(:index, params: { search: '987' })

        expect(controller.contracts).to eq([searched_contract])
      end

      it 'only sacc' do
        create(:integration_contracts_contract, isn_sic: '123')
        searched_contract = create(:integration_contracts_contract, isn_sic: '321')

        get(:index, params: { search_sacc: searched_contract.isn_sic })

        expect(controller.contracts).to eq([searched_contract])
      end
    end

    describe 'search_datalist' do
      it 'by creditor_name' do
        searched_contract = create(:integration_contracts_contract, descricao_nome_credor: 'aaa')
        create(:integration_contracts_contract, descricao_nome_credor: 'bbb')

        get(:index, params: { search_datalist: searched_contract.descricao_nome_credor })

        expect(controller.contracts).to eq([searched_contract])
      end
    end

    describe 'filters' do
      it 'by tipo_objeto' do
        contract
        create(:integration_contracts_contract)

        get(:index, params: { tipo_objeto: contract.tipo_objeto })

        expect(controller.contracts).to eq([contract])

      end

      it 'by decricao_modalidade' do
        contract
        create(:integration_contracts_contract)

        get(:index, params: { decricao_modalidade: contract.decricao_modalidade })

        expect(controller.contracts).to eq([contract])
      end

      it 'by manager' do
        organ = create(:integration_supports_organ, codigo_orgao: '1234')
        filtered_contract = create(:integration_contracts_contract, cod_gestora: organ.codigo_orgao)
        contract

        get(:index, params: { cod_gestora: organ.codigo_orgao })

        expect(controller.contracts).to eq([filtered_contract])

      end

      it 'by status' do
        concluido = create(:integration_contracts_contract, data_termino: Date.today - 1.month)
        vigente = create(:integration_contracts_contract, data_termino: Date.today + 1.month)

        get(:index, params: { status: :concluido })

        expect(controller.contracts).to eq([concluido])

        get(:index, params: { status: :vigente })

        expect(controller.contracts).to eq([vigente])
      end

      it 'by data_assinatura range' do
        in_range = create(:integration_contracts_contract, data_assinatura: Date.today)
        out_range = create(:integration_contracts_contract, data_assinatura: Date.today - 10.month)

        range = "#{I18n.l(Date.today)} - #{I18n.l(Date.today + 1.month)}"

        get(:index, params: { data_assinatura: range })

        expect(controller.contracts).to eq([in_range])
      end

      it 'by data_assinatura single' do
        in_date = create(:integration_contracts_contract, data_assinatura: Date.today)
        out_range = create(:integration_contracts_contract, data_assinatura: Date.today - 10.month)

        date = "#{I18n.l(Date.today)}"

        get(:index, params: { data_assinatura: date })

        expect(controller.contracts).to eq([in_date])
      end

      it 'by invalid data_assinatura' do
        in_range = create(:integration_contracts_contract, data_assinatura: Date.today)
        out_range = create(:integration_contracts_contract, data_assinatura: Date.today - 10.month)

        range = "blabla - blabla"

        get(:index, params: { data_assinatura: range })

        expect(controller.contracts).to eq([in_range, out_range])
      end

      it 'by data_publicacao_portal' do
        in_range = create(:integration_contracts_contract, data_publicacao_portal: Date.today)
        out_range = create(:integration_contracts_contract, data_publicacao_portal: Date.today - 10.month)

        range = "#{I18n.l(Date.today)} - #{I18n.l(Date.today + 1.month)}"

        get(:index, params: { data_publicacao_portal: range })

        expect(controller.contracts).to eq([in_range])
      end
    end

    describe 'pagination' do
      it 'calls kaminari methods' do
        allow(Integration::Contracts::Contract).to receive(:page).and_call_original
        expect(Integration::Contracts::Contract).to receive(:page).and_call_original

        get(:index)

        # para poder chamar o page que estamos testando
        controller.contracts
      end
    end
  end
end
