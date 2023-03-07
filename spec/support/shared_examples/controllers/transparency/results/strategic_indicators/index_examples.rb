# Shared example para action index de transparency/results/strategic_indicators

shared_examples_for 'controllers/transparency/results/strategic_indicators/index' do

  let(:resources) { create_list(:integration_results_strategic_indicator, 1) }

  let(:indicator) { resources.first }

  it_behaves_like 'controllers/transparency/base/index' do
    let(:sort_columns) do
      [
        'integration_supports_axes.descricao_eixo',
        'integration_supports_organs.sigla',
        'integration_results_strategic_indicators.indicador',
        'integration_results_strategic_indicators.unidade'
      ]
    end

    describe 'search' do
      it 'orgao' do
        indicator
        searched_indicator = create(:integration_results_strategic_indicator, orgao: 'ABCDEF')

        get(:index, params: { search: 'ABCDEF' })

        expect(controller.strategic_indicators).to eq([searched_indicator])
      end

      it 'nome do eixo' do
        axis = create(:integration_supports_axis, descricao_eixo: 'Nome do eixo')
        searched_indicator = create(:integration_results_strategic_indicator, axis: axis)
        indicator

        get(:index, params: { search: 'nom' })

        expect(controller.strategic_indicators).to eq([searched_indicator])
      end

      it 'indicador' do
        indicator
        searched_indicator = create(:integration_results_strategic_indicator, indicador: 'indicador')

        get(:index, params: { search: 'cad' })

        expect(controller.strategic_indicators).to eq([searched_indicator])
      end
    end

    describe 'filters' do
      describe 'associations filters' do
        it 'by organ' do
          organ = create(:integration_supports_organ, orgao_sfp: false)
          filtered_indicator = create(:integration_results_strategic_indicator, organ: organ)
          indicator

          get(:index, params: { organ_id: organ.id })

          expect(controller.strategic_indicators).to eq([filtered_indicator])
        end

        it 'by axis' do
          axis = create(:integration_supports_axis)
          filtered_indicator = create(:integration_results_strategic_indicator, axis: axis)
          indicator

          get(:index, params: { axis_id: axis.id })

          expect(controller.strategic_indicators).to eq([filtered_indicator])
        end
      end
    end
  end
end
