# Shared example para action show de transparency/expenses/profit_transfers

shared_examples_for 'controllers/transparency/expenses/profit_transfers/show' do

  let(:resources) { create_list(:integration_expenses_profit_transfer, 1) }

  let(:profit_transfer) { resources.first }

  it_behaves_like 'controllers/transparency/base/show' do
    before { get(:show, params: { id: profit_transfer }) }

    describe 'helper methods' do
      it 'profit_transfer' do
        expect(controller.profit_transfer).to eq(profit_transfer)
      end
    end

    describe 'templates' do
      render_views

      it 'responds with success and renders views without errors' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/expenses/profit_transfers/show')
      end
    end
  end
end
