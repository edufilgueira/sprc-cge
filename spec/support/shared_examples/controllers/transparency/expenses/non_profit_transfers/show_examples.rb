# Shared example para action show de transparency/expenses/non_profit_transfers

shared_examples_for 'controllers/transparency/expenses/non_profit_transfers/show' do

  let(:resources) { create_list(:integration_expenses_non_profit_transfer, 1) }

  let(:non_profit_transfer) { resources.first }

  it_behaves_like 'controllers/transparency/base/show' do
    before { get(:show, params: { id: non_profit_transfer }) }

    describe 'helper methods' do
      it 'non_profit_transfer' do
        expect(controller.non_profit_transfer).to eq(non_profit_transfer)
      end
    end

    describe 'templates' do
      render_views

      it 'responds with success and renders views without errors' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/expenses/non_profit_transfers/show')
      end
    end
  end
end
