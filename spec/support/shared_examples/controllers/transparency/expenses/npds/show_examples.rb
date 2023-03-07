# Shared example para action show de transparency/expenses/npds

shared_examples_for 'controllers/transparency/expenses/npds/show' do

  let(:resources) { create_list(:integration_expenses_npd, 1) }

  let(:npd) { resources.first }

  it_behaves_like 'controllers/transparency/base/show' do
    before { get(:show, params: { id: npd }) }

    let(:npd_item) { create(:integration_expenses_npd_item, npd: npd) }
    let(:npd_planning_item) { create(:integration_expenses_npd_planning_item, npd: npd) }
    let(:npd_disbursement_forecast) { create(:integration_expenses_npd_disbursement_forecast, npd: npd) }

    describe 'helper methods' do
      it 'npd' do
        expect(controller.npd).to eq(npd)
      end
    end

    describe 'templates' do
      render_views

      it 'responds with success and renders views without errors' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/expenses/npds/show')
      end
    end
  end
end
