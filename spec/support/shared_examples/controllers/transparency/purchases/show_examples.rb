# Shared example para action show de transparency/purchases

shared_examples_for 'controllers/transparency/purchases/show' do

  let(:purchase) { create(:integration_purchases_purchase) }

  describe '#show' do
    before { get(:show, params: { id: purchase }) }

    describe 'helper methods' do
      it 'purchase' do
        expect(controller.purchase).to eq(purchase)
      end
    end
  end
end
