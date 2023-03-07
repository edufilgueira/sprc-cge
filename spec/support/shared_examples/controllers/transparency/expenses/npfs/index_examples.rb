# Shared example para action index de transparency/expenses/npfs

shared_examples_for 'controllers/transparency/expenses/npfs/index' do

  let(:resources) { create_list(:integration_expenses_npf, 1) }

  let(:npf) { resources.first }

  it_behaves_like 'controllers/transparency/base/index' do
    let(:sort_columns) do
      [
        'integration_expenses_npfs.exercicio',
        'integration_expenses_npfs.numero',
        'integration_expenses_npfs.date_of_issue',
        'integration_supports_management_units.titulo',
        'integration_supports_creditors.nome',
        'integration_expenses_npfs.valor'
      ]
    end

    describe 'search' do
      it 'unidade_gestora' do
        npf
        searched_npf = create(:integration_expenses_npf, unidade_gestora: 'ABCDEF')

        get(:index, params: { search: 'ABCDEF' })

        expect(controller.npfs).to eq([searched_npf])
      end

      it 'creditor_nome' do
        creditor = create(:integration_supports_creditor, nome: 'João da silva')
        searched_npf = create(:integration_expenses_npf, creditor: creditor)
        npf

        get(:index, params: { search: 'silva' })

        expect(controller.npfs).to eq([searched_npf])
      end
    end

    describe 'filters' do
      it 'by range' do
        npf = create(:integration_expenses_npf, data_emissao: '29/12/2016')
        npf
        first_filtered = create(:integration_expenses_npf, data_emissao: '01/01/2017')
        middle_filtered = create(:integration_expenses_npf, data_emissao: '31/12/2016')
        last_filtered = create(:integration_expenses_npf, data_emissao: '30/12/2016')

        get(:index, params: { date_of_issue: '30/12/2016 - 01/01/2017' })

        expect(controller.npfs).to eq([first_filtered, middle_filtered, last_filtered])
      end

      it 'by unidade_gestora' do
        organ = create(:integration_supports_organ, codigo_orgao: '1234')

        npf = create(:integration_expenses_npf, unidade_gestora: 'NOT_FOUND')
        npf_filtered = create(:integration_expenses_npf, unidade_gestora: organ.codigo_orgao)

        get(:index, params: { unidade_gestora: organ.codigo_orgao })

        expect(controller.npfs).to eq([npf_filtered])
      end

      describe 'helper methods' do
        it 'filtered_count' do
          npf
          filtered = create(:integration_expenses_npf, numero: '987')

          get(:index, params: { search: '987' })

          expect(controller.filtered_count).to eq(1)
        end

        it 'filtered_sum' do
          npf
          filtered = create(:integration_expenses_npf, numero: '987', valor: 0)

          get(:index, params: { search: '987' })

          filtered_sum_column = controller.send(:filtered_sum_column)

          expect(controller.filtered_sum).to eq(filtered.send(filtered_sum_column))
        end
      end
    end
  end
end
