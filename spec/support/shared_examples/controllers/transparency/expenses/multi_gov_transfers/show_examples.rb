# Shared example para action show de transparency/expenses/multi_gov_transfers

shared_examples_for 'controllers/transparency/expenses/multi_gov_transfers/show' do

  let(:resources) { create_list(:integration_expenses_multi_gov_transfer, 1) }

  let(:multi_gov_transfer) { resources.first }

  it_behaves_like 'controllers/transparency/base/show' do
    before { get(:show, params: { id: multi_gov_transfer }) }

    describe 'helper methods' do
      it 'multi_gov_transfer' do
        expect(controller.multi_gov_transfer).to eq(multi_gov_transfer)
      end
    end

    describe 'templates' do
      render_views

      it 'responds with success and renders views without errors' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/expenses/multi_gov_transfers/show')
      end
    end
  end
end
