# Shared example para action show de transparency/expenses/npfs

shared_examples_for 'controllers/transparency/expenses/npfs/show' do

  let(:resources) { create_list(:integration_expenses_npf, 1) }

  let(:npf) { resources.first }

  it_behaves_like 'controllers/transparency/base/show' do
    before { get(:show, params: { id: npf }) }

    let(:npf_item) { create(:integration_expenses_npf_item, npf: npf) }
    let(:npf_planning_item) { create(:integration_expenses_npf_planning_item, npf: npf) }
    let(:npf_disbursement_forecast) { create(:integration_expenses_npf_disbursement_forecast, npf: npf) }

    describe 'helper methods' do
      it 'npf' do
        expect(controller.npf).to eq(npf)
      end
    end

    describe 'templates' do
      render_views

      it 'responds with success and renders views without errors' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/expenses/npfs/show')
      end
    end
  end
end
