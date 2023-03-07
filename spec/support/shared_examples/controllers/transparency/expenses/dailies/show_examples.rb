# Shared example para action show de transparency/expenses/dailies

shared_examples_for 'controllers/transparency/expenses/dailies/show' do

  let(:resources) { create_list(:integration_expenses_daily, 1) }

  let(:daily) { resources.first }

  it_behaves_like 'controllers/transparency/base/show' do
    before { get(:show, params: { id: daily }) }

    describe 'helper methods' do
      it 'daily' do
        expect(controller.daily).to eq(daily)
      end
    end

    describe 'templates' do
      render_views

      it 'responds with success and renders views without errors' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/expenses/dailies/show')
      end
    end
  end
end
