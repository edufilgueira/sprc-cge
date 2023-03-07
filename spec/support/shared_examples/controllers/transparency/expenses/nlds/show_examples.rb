# Shared example para action show de transparency/expenses/nlds

shared_examples_for 'controllers/transparency/expenses/nlds/show' do

  let(:resources) { create_list(:integration_expenses_nld, 1) }

  let(:nld) { resources.first }

  it_behaves_like 'controllers/transparency/base/show' do
    before { get(:show, params: { id: nld }) }

    let(:nld_item) { create(:integration_expenses_nld_item, nld: nld) }
    let(:nld_planning_item) { create(:integration_expenses_nld_planning_item, nld: nld) }
    let(:nld_disbursement_forecast) { create(:integration_expenses_nld_disbursement_forecast, nld: nld) }

    describe 'helper methods' do
      it 'nld' do
        expect(controller.nld).to eq(nld)
      end
    end

    describe 'templates' do
      render_views

      it 'responds with success and renders views without errors' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/expenses/nlds/show')
      end
    end
  end
end
