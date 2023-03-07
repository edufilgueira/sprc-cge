# Shared example para action index de transparency/expenses/dailies

shared_examples_for 'controllers/transparency/expenses/dailies/index' do

  let(:year) { Date.today.year }

  let(:resources) { create_list(:integration_expenses_daily, 1, exercicio: year, unidade_gestora: management_unit.codigo) }

  let(:daily) { resources.first }

  let(:management_unit) { create(:integration_supports_management_unit, poder: 'EXECUTIVO', sigla: 'SIGLA1234456', codigo: '9393929299299393939') }

  it_behaves_like 'controllers/transparency/base/index' do
    let(:sort_columns) do
      [
        'integration_expenses_npds.numero',
        'integration_expenses_npds.data_emissao',
        'integration_supports_management_units.titulo',
        'integration_expenses_neds.razao_social_credor',
        'integration_expenses_npds.calculated_valor_final'
      ]
    end

    describe 'search' do
      it 'unidade_gestora' do
        daily
        searched_daily = create(:integration_expenses_daily, exercicio: year, unidade_gestora: '123321')
        management_unit = create(:integration_supports_management_unit, poder: 'EXECUTIVO', codigo: searched_daily.unidade_gestora)

        get(:index, params: { search: searched_daily.unidade_gestora })

        expect(controller.dailies).to eq([searched_daily])
      end

      it 'credor' do
        daily
        searched_management_unit = create(:integration_supports_management_unit, poder: 'EXECUTIVO', codigo: '1234567')
        searched = create(:integration_expenses_daily, credor: 'ABCDEF', exercicio: year, unidade_gestora: searched_management_unit.codigo)

        get(:index, params: { search: 'ABCDEF' })

        expect(controller.dailies).to eq([searched])
      end
    end


    describe 'search_datalist' do
      it 'credor' do
        credor = 'credor123456'

        create(:integration_expenses_daily, unidade_gestora: management_unit.codigo)
        searched = create(:integration_expenses_daily, unidade_gestora: management_unit.codigo)

        searched.nld.ned.razao_social_credor = credor
        searched.nld.ned.save

        get(:index, params: { search_datalist: credor })

        expect(controller.dailies).to eq([searched])
      end
    end

    describe 'filters' do
      it 'by exercicio' do
        daily = create(:integration_expenses_daily, exercicio: year, unidade_gestora: management_unit.codigo, data_emissao: "29/12/#{year}")
        first_filtered = create(:integration_expenses_daily, exercicio: year - 1, unidade_gestora: management_unit.codigo, data_emissao: "01/01/#{year + 1}")
        middle_filtered = create(:integration_expenses_daily, exercicio: year - 1, unidade_gestora: management_unit.codigo, data_emissao: "31/12/#{year}")
        last_filtered = create(:integration_expenses_daily, exercicio: year, unidade_gestora: management_unit.codigo, data_emissao: "30/12/#{year}")

        get(:index, params: { exercicio: year })

        expect(controller.dailies).to match_array([daily, last_filtered])
      end

      it 'by unidade_gestora' do
        daily = create(:integration_expenses_daily, exercicio: year, unidade_gestora: 'NOT_FOUND')
        daily_filtered = create(:integration_expenses_daily, exercicio: year, unidade_gestora: management_unit.codigo)

        get(:index, params: { unidade_gestora: management_unit.codigo })

        expect(controller.dailies).to include(daily_filtered)
        expect(controller.dailies).not_to include(daily)
      end

      it 'by date range' do
        daily = create(:integration_expenses_daily, exercicio: year, unidade_gestora: management_unit.codigo, data_emissao: "29/12/#{year}")
        another = create(:integration_expenses_daily, exercicio: year, unidade_gestora: management_unit.codigo, data_emissao: "31/12/#{year}")
        non_filtered = create(:integration_expenses_daily, exercicio: year, unidade_gestora: management_unit.codigo, data_emissao: "27/12/#{year}")

        get(:index, params: {year: year, date_of_issue: "28/12/#{year}- 31/12/#{year}" })

        expect(controller.dailies).to match_array([daily, another])
      end
    end

    describe 'helper methods' do
      it 'filtered_count' do
        daily
        filtered = create(:integration_expenses_daily, exercicio: year, unidade_gestora: management_unit.codigo, numero: '987')

        get(:index, params: { search: '987' })

        expect(controller.filtered_count).to eq(1)
      end

      it 'filtered_sum' do
        daily
        filtered = create(:integration_expenses_daily, exercicio: year, unidade_gestora: management_unit.codigo, numero: '987', valor: 1)

        get(:index, params: { search: '987' })

        filtered_resources = controller.dailies

        expected = {
          calculated_valor_final: filtered_resources.sum(:calculated_valor_final)
        }

        expect(controller.filtered_sum).to eq(expected)
      end
    end
  end
end
