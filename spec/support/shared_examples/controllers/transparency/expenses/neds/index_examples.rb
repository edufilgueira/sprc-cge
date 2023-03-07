# Shared example para action index de transparency/expenses/neds

shared_examples_for 'controllers/transparency/expenses/neds/index' do

  let(:year) { Date.today.year }

  let(:resources) { create_list(:integration_expenses_ned, 1, exercicio: year, unidade_gestora: management_unit.codigo) }

  let(:management_unit) { create(:integration_supports_management_unit, poder: 'EXECUTIVO', sigla: 'SIGLA1234456', codigo: '9393929299299393939') }

  let(:ned) { resources.first }

  it_behaves_like 'controllers/transparency/base/index' do
    let(:sort_columns) do
      [
        'integration_expenses_neds.numero',
        'integration_expenses_neds.date_of_issue',
        'integration_supports_management_units.titulo',
        'integration_expenses_neds.razao_social_credor',
        'integration_expenses_neds.valor',
        'integration_expenses_neds.calculated_valor_pago_final'
      ]
    end

    describe 'default_scope' do
      it 'lists only ordinarias' do
        suplementacao = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo, natureza: 'Suplementação')
        ordinaria = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo, natureza: 'Ordinária')
        anulacao = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo, natureza: 'Anulação')

        expect(controller.neds).to eq([ordinaria])
      end
    end

    describe 'search' do
      it 'unidade_gestora' do
        searched_ned = ned

        another_management_unit = create(:integration_supports_management_unit, poder: 'EXECUTIVO')
        another_ned = create(:integration_expenses_ned, unidade_gestora: another_management_unit.codigo)

        get(:index, params: { search: management_unit.codigo })

        expect(controller.neds).to eq([searched_ned])
      end

      it 'management_unit sigla' do
        searched_ned = ned

        another_management_unit = create(:integration_supports_management_unit, poder: 'EXECUTIVO', sigla: 'NOT_FOUND')
        another_ned = create(:integration_expenses_ned, unidade_gestora: another_management_unit.codigo)

        get(:index, params: { search: management_unit.sigla })

        expect(controller.neds).to eq([searched_ned])
      end

      it 'razao_social_credor' do
        ned
        searched_ned = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo, razao_social_credor: 'ABCDEF')

        get(:index, params: { search: 'ABCDEF' })

        expect(controller.neds).to eq([searched_ned])
      end
    end

    describe 'search_datalist' do
      it 'credor' do
        create(:integration_expenses_ned, razao_social_credor: 'aaa', unidade_gestora: management_unit.codigo)
        searched_ned = create(:integration_expenses_ned, razao_social_credor: 'bbb', unidade_gestora: management_unit.codigo)

        get(:index, params: { search_datalist: 'bbb' })

        expect(controller.neds).to eq([searched_ned])
      end
    end

    describe 'filters' do
      it 'by year' do
        ned = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo, exercicio: Date.today.year)
        another_ned = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo, exercicio: Date.today.year - 2.years)

        get(:index, params: { year: ned.exercicio })

        expect(controller.neds).to eq([ned])
      end

      it 'by range' do
        ned = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo, data_emissao: '29/12/2016', exercicio: '2016')
        first_filtered = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo, data_emissao: '01/01/2017', exercicio: '2017')
        middle_filtered = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo, data_emissao: '31/12/2016', exercicio: '2016')
        last_filtered = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo, data_emissao: '30/12/2016', exercicio: '2016')

        get(:index, params: { date_of_issue: '30/12/2016 - 01/01/2017' })

        expect(controller.neds).to eq([first_filtered, middle_filtered, last_filtered])
      end

      it 'by unidade_gestora' do
        ned = create(:integration_expenses_ned, unidade_gestora: 'NOT_FOUND')
        ned_filtered = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo)

        get(:index, params: { unidade_gestora: management_unit.codigo })

        expect(controller.neds).to eq([ned_filtered])
      end

      it 'by item_despesa' do
        ned = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo, item_despesa: 'NOT_FOUND')
        ned_filtered = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo)

        get(:index, params: { item_despesa: ned_filtered.item_despesa })

        expect(controller.neds).to eq([ned_filtered])
      end

      it 'by classificacao_elemento_despesa' do
        ned = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo, item_despesa: 'NOT_FOUND')
        ned_filtered = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo)

        get(:index, params: { classificacao_elemento_despesa: ned_filtered.classificacao_elemento_despesa })

        expect(controller.neds).to eq([ned_filtered])
      end

      it 'by numero' do
        ned = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo, numero: 'NOT_FOUND')
        ned_filtered = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo, numero: '1234')

        get(:index, params: { numero: '234' })

        expect(controller.neds).to eq([ned_filtered])
      end

      describe 'associations filters' do
        let(:function) { create(:integration_supports_function) }
        let(:sub_function) { create(:integration_supports_sub_function) }
        let(:government_program) { create(:integration_supports_government_program, codigo_programa: '003') }
        let(:administrative_region) { create(:integration_supports_administrative_region, codigo_regiao: '0300000') }
        let(:expense_nature) { create(:integration_supports_expense_nature) }
        let(:resource_source) { create(:integration_supports_resource_source) }
        let(:expense_type) { create(:integration_supports_expense_type) }

        let(:filtered_ned) do
          associations = {
            function: function,
            sub_function: sub_function,
            government_program: government_program,
            administrative_region: administrative_region,
            expense_nature: expense_nature,
            resource_source: resource_source,
            expense_type: expense_type,
            unidade_gestora: management_unit.codigo
          }

          create(:integration_expenses_ned, associations)
        end

        let(:unfiltered_ned) { create(:integration_expenses_ned, :without_associations) }

        it 'by function' do
          expect(filtered_ned.function).to eq(function)
          expect(unfiltered_ned.function).not_to eq(function)
          params = { classificacao_funcao: function.codigo_funcao }

          get(:index, params: params)

          expect(controller.neds).to eq([filtered_ned])
        end

        it 'by sub_function' do
          expect(filtered_ned.sub_function).to eq(sub_function)
          expect(unfiltered_ned.sub_function).not_to eq(sub_function)

          params = { classificacao_subfuncao: sub_function.codigo_sub_funcao }

          get(:index, params: params)

          expect(controller.neds).to eq([filtered_ned])
        end

        it 'by government_program' do
          expect(filtered_ned.government_program).to eq(government_program)
          expect(unfiltered_ned.government_program).not_to eq(government_program)

          params = { classificacao_programa_governo: government_program.codigo_programa }

          get(:index, params: params)

          expect(controller.neds).to eq([filtered_ned])
        end

        it 'by administrative_region' do
          expect(filtered_ned.administrative_region).to eq(administrative_region)
          expect(unfiltered_ned.administrative_region).not_to eq(administrative_region)

          params = { classificacao_regiao_administrativa: administrative_region.codigo_regiao_resumido }

          get(:index, params: params)

          expect(controller.neds).to eq([filtered_ned])
        end

        it 'by expense_nature' do
          expect(filtered_ned.expense_nature).to eq(expense_nature)
          expect(unfiltered_ned.expense_nature).not_to eq(expense_nature)

          params = { classificacao_natureza_despesa: expense_nature.codigo_natureza_despesa }

          get(:index, params: params)

          expect(controller.neds).to eq([filtered_ned])
        end

        it 'by resource_source' do
          expect(filtered_ned.resource_source).to eq(resource_source)
          expect(unfiltered_ned.resource_source).not_to eq(resource_source)


          params = { classificacao_fonte_recursos: resource_source.codigo_fonte }

          get(:index, params: params)

          expect(controller.neds).to eq([filtered_ned])
        end
      end

      describe 'helper methods' do
        it 'filtered_count' do
          ned
          filtered = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo, numero: '987')

          get(:index, params: { search: '987' })

          expect(controller.filtered_count).to eq(1)
        end

        it 'filtered_sum' do
          ned
          filtered = create(:integration_expenses_ned, unidade_gestora: management_unit.codigo, numero: '987')

          get(:index, params: { search: '987' })

          calculated_valor_final = controller.filtered_resources.sum(:calculated_valor_final)
          calculated_valor_pago_final = controller.filtered_resources.sum(:calculated_valor_pago_final)

          expected = {
            calculated_valor_final: calculated_valor_final,
            calculated_valor_pago_final: calculated_valor_pago_final
          }

          expect(controller.filtered_sum).to eq(expected)
        end
      end
    end
  end
end
