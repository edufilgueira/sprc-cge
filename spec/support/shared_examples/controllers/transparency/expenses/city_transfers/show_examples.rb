# Shared example para action show de transparency/expenses/city_transfers

shared_examples_for 'controllers/transparency/expenses/city_transfers/show' do

  let(:resources) { create_list(:integration_expenses_city_transfer, 1) }

  let(:city_transfer) { resources.first }

  it_behaves_like 'controllers/transparency/base/show' do
    before { get(:show, params: { id: city_transfer }) }

    describe 'helper methods' do
      it 'city_transfer' do
        expect(controller.city_transfer).to eq(city_transfer)
      end
    end

    describe 'templates' do
      render_views

      it 'responds with success and renders views without errors' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/expenses/city_transfers/show')
      end
    end
  end
end
