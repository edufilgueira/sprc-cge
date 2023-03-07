# Shared example para action index de transparency/results/thematic_indicators

shared_examples_for 'controllers/transparency/results/thematic_indicators/index' do

  let(:resources) { create_list(:integration_results_thematic_indicator, 1) }

  let(:indicator) { resources.first }

  it_behaves_like 'controllers/transparency/base/index' do
    let(:sort_columns) do
      [
        'integration_supports_axes.descricao_eixo',
        'integration_supports_themes.descricao_tema',
        'integration_supports_organs.sigla',
        'integration_results_thematic_indicators.indicador',
        'integration_results_thematic_indicators.unidade'
      ]
    end

    describe 'search' do
      it 'orgao' do
        indicator
        searched_indicator = create(:integration_results_thematic_indicator, orgao: 'ABCDEF')

        get(:index, params: { search: 'ABCDEF' })

        expect(controller.thematic_indicators).to eq([searched_indicator])
      end

      it 'nome do eixo' do
        axis = create(:integration_supports_axis, descricao_eixo: 'Nome do eixo')
        searched_indicator = create(:integration_results_thematic_indicator, axis: axis)
        indicator

        get(:index, params: { search: 'nom' })

        expect(controller.thematic_indicators).to eq([searched_indicator])
      end

      it 'nome do tema' do
        theme = create(:integration_supports_theme, descricao_tema: 'Nome do tema')
        searched_indicator = create(:integration_results_thematic_indicator, theme: theme)
        indicator

        get(:index, params: { search: 'nom' })

        expect(controller.thematic_indicators).to eq([searched_indicator])
      end

      it 'indicador' do
        indicator
        searched_indicator = create(:integration_results_thematic_indicator, indicador: 'indicador')

        get(:index, params: { search: 'cad' })

        expect(controller.thematic_indicators).to eq([searched_indicator])
      end
    end

    describe 'filters' do
      describe 'associations filters' do
        it 'by organ' do
          organ = create(:integration_supports_organ)
          filtered_indicator = create(:integration_results_thematic_indicator, organ: organ)
          indicator

          get(:index, params: { organ_id: organ.id })

          expect(controller.thematic_indicators).to eq([filtered_indicator])
        end

        it 'by axis' do
          axis = create(:integration_supports_axis)
          filtered_indicator = create(:integration_results_thematic_indicator, axis: axis)
          indicator

          get(:index, params: { axis_id: axis.id })

          expect(controller.thematic_indicators).to eq([filtered_indicator])
        end


        it 'by theme' do
          theme = create(:integration_supports_theme)
          filtered_indicator = create(:integration_results_thematic_indicator, theme: theme)
          indicator

          get(:index, params: { theme_id: theme.id })

          expect(controller.thematic_indicators).to eq([filtered_indicator])
        end
      end
    end
  end
end
