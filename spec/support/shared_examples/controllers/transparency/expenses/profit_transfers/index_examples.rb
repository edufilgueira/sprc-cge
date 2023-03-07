# Shared example para action index de transparency/expenses/profit_transfers

shared_examples_for 'controllers/transparency/expenses/profit_transfers/index' do
  let(:year) { Date.today.year }

  let(:resources) { create_list(:integration_expenses_profit_transfer, 1, exercicio: year, unidade_gestora: management_unit.codigo) }

  let(:profit_transfer) { resources.first }

  let(:management_unit) { create(:integration_supports_management_unit, poder: 'EXECUTIVO', sigla: 'SIGLA1234456', codigo: '9393929299299393939') }

  it_behaves_like 'controllers/transparency/base/index' do
    let(:sort_columns) do
      [
        'integration_expenses_neds.numero',
        'integration_expenses_neds.date_of_issue',
        'integration_supports_management_units.titulo',
        'integration_expenses_neds.razao_social_credor',
        'integration_supports_expense_nature_items.titulo',
        'integration_expenses_neds.valor',
        'integration_expenses_neds.valor_pago'
      ]
    end

    describe 'search' do
      it 'unidade_gestora' do
        profit_transfer
        searched_management_unit = create(:integration_supports_management_unit, poder: 'EXECUTIVO', codigo: '1234567')
        searched_profit_transfer = create(:integration_expenses_profit_transfer, exercicio: year, unidade_gestora: searched_management_unit.codigo)

        get(:index, params: { search: searched_management_unit.codigo, year: year })

        expect(controller.profit_transfers).to eq([searched_profit_transfer])
      end

      it 'razao_social_credor' do
        profit_transfer
        searched_management_unit = create(:integration_supports_management_unit, poder: 'EXECUTIVO', codigo: '1234567')
        searched = create(:integration_expenses_profit_transfer, razao_social_credor: 'ABCDEF', exercicio: year, unidade_gestora: searched_management_unit.codigo)

        get(:index, params: { search: 'ABCDEF', year: year })

        expect(controller.profit_transfers).to eq([searched])
      end
    end

    describe 'filters' do
      it 'by year' do
        profit_transfer = create(:integration_expenses_profit_transfer, exercicio: year, unidade_gestora: management_unit.codigo, data_emissao: "29/12/#{year}")
        first_filtered = create(:integration_expenses_profit_transfer, exercicio: year + 1, unidade_gestora: management_unit.codigo, data_emissao: "01/01/#{year + 1}")
        middle_filtered = create(:integration_expenses_profit_transfer, exercicio: year, unidade_gestora: management_unit.codigo, data_emissao: "31/12/#{year}")
        last_filtered = create(:integration_expenses_profit_transfer, exercicio: year, unidade_gestora: management_unit.codigo, data_emissao: "30/12/#{year}")

        get(:index, params: { year: year })

        expect(controller.profit_transfers).to match_array([profit_transfer, middle_filtered, last_filtered])
      end

      it 'by unidade_gestora' do
        profit_transfer = create(:integration_expenses_profit_transfer, exercicio: year, unidade_gestora: 'NOT_FOUND')
        profit_transfer_filtered = create(:integration_expenses_profit_transfer, exercicio: year, unidade_gestora: management_unit.codigo)

        get(:index, params: { unidade_gestora: management_unit.codigo, year: year })

        expect(controller.profit_transfers).to include(profit_transfer_filtered)
        expect(controller.profit_transfers).not_to include(profit_transfer)
      end

      describe 'associations filters' do
        let(:function) { create(:integration_supports_function) }
        let(:sub_function) { create(:integration_supports_sub_function) }
        let(:government_program) { create(:integration_supports_government_program) }
        let(:administrative_region) { create(:integration_supports_administrative_region, codigo_regiao: '0300000') }
        let(:expense_nature) { create(:integration_supports_expense_nature) }
        let(:expense_nature_item) { create(:integration_supports_expense_nature_item, codigo_item_natureza: '0060000000') }
        let(:resource_source) { create(:integration_supports_resource_source) }
        let(:expense_type) { create(:integration_supports_expense_type) }

        let(:filtered_profit_transfer) do
          associations = {
            exercicio: year,
            function: function,
            sub_function: sub_function,
            government_program: government_program,
            administrative_region: administrative_region,
            expense_nature: expense_nature,
            resource_source: resource_source,
            expense_type: expense_type,
            expense_nature_item: expense_nature_item,
            unidade_gestora: management_unit.codigo
          }

          create(:integration_expenses_profit_transfer, associations)
        end

        let(:unfiltered_profit_transfer) { create(:integration_expenses_profit_transfer, :without_associations, exercicio: year, item_despesa: '01247165666666666666') }

        it 'by administrative_region' do
          expect(filtered_profit_transfer.administrative_region).to eq(administrative_region)
          expect(unfiltered_profit_transfer.administrative_region).not_to eq(administrative_region)

          params = { classificacao_regiao_administrativa: administrative_region.codigo_regiao_resumido, year: year }

          get(:index, params: params)

          expect(controller.profit_transfers).to eq([filtered_profit_transfer])
        end

        it 'by date range' do
          profit_transfer = create(:integration_expenses_profit_transfer, exercicio: year, unidade_gestora: management_unit.codigo, data_emissao: "29/12/#{year}")
          another = create(:integration_expenses_profit_transfer, exercicio: year, unidade_gestora: management_unit.codigo, data_emissao: "31/12/#{year}")
          filtered = create(:integration_expenses_profit_transfer, exercicio: year, unidade_gestora: management_unit.codigo, data_emissao: "27/12/#{year}")

          get(:index, params: {year: year, date_of_issue: "28/12/#{year}- 31/12/#{year}" })

          expect(controller.profit_transfers).to match_array([profit_transfer, another])
        end
      end

      describe 'helper methods' do
        it 'filtered_count' do
          profit_transfer
          filtered = create(:integration_expenses_profit_transfer, exercicio: year, unidade_gestora: management_unit.codigo, numero: '987')

          get(:index, params: { search: '987', year: year })

          expect(controller.filtered_count).to eq(1)
        end

        it 'filtered_sum' do
          profit_transfer
          filtered = create(:integration_expenses_profit_transfer, exercicio: year, unidade_gestora: management_unit.codigo, numero: '987', valor: 1, valor_pago: 2)

          get(:index, params: { search: '987' })

          filtered_resources = controller.profit_transfers

          expected = {
            valor: filtered_resources.sum(:calculated_valor_final),
            valor_pago: filtered_resources.sum(:calculated_valor_pago_final)
          }

          expect(controller.filtered_sum).to eq(expected)
        end
      end
    end
  end
end
