
# Shared example para action index de transparency/expenses/fund_supplies

shared_examples_for 'controllers/transparency/expenses/fund_supplies/index' do

  let(:year) { Date.today.year }

  let(:resources) { create_list(:integration_expenses_fund_supply, 1, exercicio: year, unidade_gestora: management_unit.codigo) }

  let(:fund_supply) { resources.first }

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
      before { create(:stats_expenses_fund_supply, month: 0, month_start: 1, month_end:1) }

      it 'unidade_gestora' do
        fund_supply
        searched_management_unit = create(:integration_supports_management_unit, poder: 'EXECUTIVO', codigo: '1234567')
        searched_fund_supply = create(:integration_expenses_fund_supply, exercicio: year, unidade_gestora: searched_management_unit.codigo)

        get(:index, params: { search: searched_management_unit.codigo })

        expect(controller.fund_supplies).to eq([searched_fund_supply])
      end

      it 'razao_social_credor' do
        fund_supply
        searched_management_unit = create(:integration_supports_management_unit, poder: 'EXECUTIVO', codigo: '1234567')
        searched = create(:integration_expenses_fund_supply, razao_social_credor: 'ABCDEF', exercicio: year, unidade_gestora: searched_management_unit.codigo)

        get(:index, params: { search: 'ABCDEF' })

        expect(controller.fund_supplies).to eq([searched])
      end
    end

    describe 'filters' do
      before { create(:stats_expenses_fund_supply, month: 0, month_start: 1, month_end:1) }

      it 'by year' do
        fund_supply = create(:integration_expenses_fund_supply, exercicio: year, unidade_gestora: management_unit.codigo, data_emissao: "29/12/#{year}")
        first_filtered = create(:integration_expenses_fund_supply, exercicio: year + 1, unidade_gestora: management_unit.codigo, data_emissao: "01/01/#{year + 1}")
        middle_filtered = create(:integration_expenses_fund_supply, exercicio: year, unidade_gestora: management_unit.codigo, data_emissao: "31/12/#{year}")
        last_filtered = create(:integration_expenses_fund_supply, exercicio: year, unidade_gestora: management_unit.codigo, data_emissao: "30/12/#{year}")

        get(:index, params: { year: year })

        expect(controller.fund_supplies).to match_array([fund_supply, middle_filtered, last_filtered])
      end

      it 'by range' do
        fund_supply = create(:integration_expenses_fund_supply, unidade_gestora: management_unit.codigo, data_emissao: '29/12/2016', exercicio: '2016')
        first_filtered = create(:integration_expenses_fund_supply, unidade_gestora: management_unit.codigo, data_emissao: '01/01/2017', exercicio: '2017')
        middle_filtered = create(:integration_expenses_fund_supply, unidade_gestora: management_unit.codigo, data_emissao: '31/12/2016', exercicio: '2016')
        last_filtered = create(:integration_expenses_fund_supply, unidade_gestora: management_unit.codigo, data_emissao: '30/12/2016', exercicio: '2016')

        get(:index, params: { date_of_issue: '30/12/2016 - 01/01/2017', year: ['2016', '2017'] })

        expect(controller.fund_supplies).to eq([first_filtered, middle_filtered, last_filtered])
      end

      it 'by unidade_gestora' do
        fund_supply = create(:integration_expenses_fund_supply, exercicio: year, unidade_gestora: 'NOT_FOUND')
        fund_supply_filtered = create(:integration_expenses_fund_supply, exercicio: year, unidade_gestora: management_unit.codigo)
        
        get(:index, params: { unidade_gestora: management_unit.codigo })

        expect(controller.fund_supplies).to include(fund_supply_filtered)
        expect(controller.fund_supplies).not_to include(fund_supply)
      end

      describe 'associations filters' do
        let(:function) { create(:integration_supports_function) }
        let(:sub_function) { create(:integration_supports_sub_function) }
        let(:government_program) { create(:integration_supports_government_program) }
        let(:administrative_region) { create(:integration_supports_administrative_region, codigo_regiao: '0300000') }
        let(:expense_nature) { create(:integration_supports_expense_nature) }
        let(:expense_nature_item) { create(:integration_supports_expense_nature_item, codigo_item_natureza: '33903000096') }
        let(:resource_source) { create(:integration_supports_resource_source) }
        let(:expense_type) { create(:integration_supports_expense_type) }

        let(:filtered_fund_supply) do
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

          create(:integration_expenses_fund_supply, associations)
        end

        let(:unfiltered_fund_supply) { create(:integration_expenses_fund_supply, :without_associations, exercicio: year, item_despesa: '01247165666666666666') }

        it 'by administrative_region' do
          expect(filtered_fund_supply.administrative_region).to eq(administrative_region)
          expect(unfiltered_fund_supply.administrative_region).not_to eq(administrative_region)

          params = { classificacao_regiao_administrativa: administrative_region.codigo_regiao_resumido }

          get(:index, params: params)

          expect(controller.fund_supplies).to eq([filtered_fund_supply])
        end

        it 'by date range' do
          fund_supply = create(:integration_expenses_fund_supply, exercicio: year, unidade_gestora: management_unit.codigo, data_emissao: "29/12/#{year}")
          another = create(:integration_expenses_fund_supply, exercicio: year, unidade_gestora: management_unit.codigo, data_emissao: "31/12/#{year}")
          non_filtered = create(:integration_expenses_fund_supply, exercicio: year, unidade_gestora: management_unit.codigo, data_emissao: "27/12/#{year}")

          get(:index, params: {year: year, date_of_issue: "28/12/#{year}- 31/12/#{year}" })

          expect(controller.fund_supplies).to match_array([fund_supply, another])
        end
      end

      describe 'helper methods' do
        it 'filtered_count' do
          fund_supply
          filtered = create(:integration_expenses_fund_supply, exercicio: year, unidade_gestora: management_unit.codigo, numero: '987')

          get(:index, params: { search: '987' })

          expect(controller.filtered_count).to eq(1)
        end

        it 'filtered_sum' do
          fund_supply
          filtered = create(:integration_expenses_fund_supply, exercicio: year, unidade_gestora: management_unit.codigo, numero: '987', valor: 1, valor_pago: 2)

          get(:index, params: { search: '987' })

          filtered_resources = controller.fund_supplies

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
