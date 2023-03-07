# Shared example para action show de transparency/expenses/consortium_transfers

shared_examples_for 'controllers/transparency/expenses/consortium_transfers/show' do

  let(:resources) { create_list(:integration_expenses_consortium_transfer, 1) }

  let(:consortium_transfer) { resources.first }

  it_behaves_like 'controllers/transparency/base/show' do
    before { get(:show, params: { id: consortium_transfer }) }

    describe 'helper methods' do
      it 'consortium_transfer' do
        expect(controller.consortium_transfer).to eq(consortium_transfer)
      end
    end

    describe 'templates' do
      render_views

      it 'responds with success and renders views without errors' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/expenses/consortium_transfers/show')
      end
    end
  end
end
