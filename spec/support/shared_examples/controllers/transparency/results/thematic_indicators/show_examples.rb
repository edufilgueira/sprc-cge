# Shared example para action show de transparency/results/thematic_indicators

shared_examples_for 'controllers/transparency/results/thematic_indicators/show' do

  let(:resources) { create_list(:integration_results_thematic_indicator, 1) }

  let(:thematic_indicator) { resources.first }

  it_behaves_like 'controllers/transparency/base/show' do
    before { get(:show, params: { id: thematic_indicator }) }

    describe 'helper methods' do
      it 'thematic_indicator' do
        expect(controller.thematic_indicator).to eq(thematic_indicator)
      end
    end

    describe 'templates' do
      render_views

      it 'responds with success and renders views without errors' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/results/thematic_indicators/show')
      end
    end
  end
end
