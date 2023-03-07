# Shared example para action show de transparency/results/strategic_indicators

shared_examples_for 'controllers/transparency/results/strategic_indicators/show' do

  let(:resources) { create_list(:integration_results_strategic_indicator, 1) }

  let(:strategic_indicator) { resources.first }

  it_behaves_like 'controllers/transparency/base/show' do
    before { get(:show, params: { id: strategic_indicator }) }

    describe 'helper methods' do
      it 'strategic_indicator' do
        expect(controller.strategic_indicator).to eq(strategic_indicator)
      end
    end

    describe 'templates' do
      render_views

      it 'responds with success and renders views without errors' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/results/strategic_indicators/show')
      end
    end
  end
end
