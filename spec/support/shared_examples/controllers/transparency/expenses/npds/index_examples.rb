# Shared example para action index de transparency/expenses/npds

shared_examples_for 'controllers/transparency/expenses/npds/index' do

  let(:resources) { create_list(:integration_expenses_npd, 1) }

  let(:npd) { resources.first }

  it_behaves_like 'controllers/transparency/base/index' do
    let(:sort_columns) do
      [
        'integration_expenses_npds.exercicio',
        'integration_expenses_npds.numero',
        'integration_expenses_npds.date_of_issue',
        'integration_supports_management_units.titulo',
        'integration_supports_creditors.nome',
        'integration_expenses_npds.valor'
      ]
    end

    describe 'search' do
      it 'unidade_gestora' do
        npd
        searched_npd = create(:integration_expenses_npd, unidade_gestora: 'ABCDEF')

        get(:index, params: { search: 'ABCDEF' })

        expect(controller.npds).to eq([searched_npd])
      end

      it 'creditor_nome' do
        creditor = create(:integration_supports_creditor, nome: 'João da silva')
        searched_npd = create(:integration_expenses_npd, creditor: creditor)
        npd

        get(:index, params: { search: 'silva' })

        expect(controller.npds).to eq([searched_npd])
      end
    end

    describe 'filters' do
      it 'by range' do
        npd = create(:integration_expenses_npd, data_emissao: '29/12/2016')
        npd
        first_filtered = create(:integration_expenses_npd, data_emissao: '01/01/2017')
        middle_filtered = create(:integration_expenses_npd, data_emissao: '31/12/2016')
        last_filtered = create(:integration_expenses_npd, data_emissao: '30/12/2016')

        get(:index, params: { date_of_issue: '30/12/2016 - 01/01/2017' })

        expect(controller.npds).to eq([first_filtered, middle_filtered, last_filtered])
      end

      it 'by unidade_gestora' do
        organ = create(:integration_supports_organ, codigo_orgao: '1234')

        npd = create(:integration_expenses_npd, unidade_gestora: 'NOT_FOUND')
        npd_filtered = create(:integration_expenses_npd, unidade_gestora: organ.codigo_orgao)

        get(:index, params: { unidade_gestora: organ.codigo_orgao })

        expect(controller.npds).to eq([npd_filtered])
      end

      describe 'helper methods' do
        it 'filtered_count' do
          npd
          filtered = create(:integration_expenses_npd, numero: '987')

          get(:index, params: { search: '987' })

          expect(controller.filtered_count).to eq(1)
        end

        it 'filtered_sum' do
          npd
          filtered = create(:integration_expenses_npd, numero: '987', valor: 0)

          get(:index, params: { search: '987' })

          filtered_sum_column = controller.send(:filtered_sum_column)

          expect(controller.filtered_sum).to eq(filtered.send(filtered_sum_column))
        end
      end
    end
  end
end
