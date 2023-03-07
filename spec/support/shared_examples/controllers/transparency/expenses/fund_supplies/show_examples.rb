# Shared example para action show de transparency/expenses/fund_supplies

shared_examples_for 'controllers/transparency/expenses/fund_supplies/show' do

  let(:resources) { create_list(:integration_expenses_fund_supply, 1) }

  let(:fund_supply) { resources.first }

  it_behaves_like 'controllers/transparency/base/show' do
    before { get(:show, params: { id: fund_supply }) }

    describe 'helper methods' do
      it 'fund_supply' do
        expect(controller.fund_supply).to eq(fund_supply)
      end
    end

    describe 'templates' do
      render_views

      it 'responds with success and renders views without errors' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/expenses/fund_supplies/show')
      end
    end
  end
end
