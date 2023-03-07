# Shared example para action show de transparency/expenses/neds

shared_examples_for 'controllers/transparency/expenses/neds/show' do

  let(:resources) { create_list(:integration_expenses_ned, 1) }

  let(:ned) { resources.first }

  it_behaves_like 'controllers/transparency/base/show' do
    before { get(:show, params: { id: ned }) }

    let(:ned_item) { create(:integration_expenses_ned_item, ned: ned) }
    let(:ned_planning_item) { create(:integration_expenses_ned_planning_item, ned: ned) }

    describe 'helper methods' do
      it 'ned' do
        expect(controller.ned).to eq(ned)
      end
      it 'ned_item' do
        expect(controller.ned_items).to eq([ned_item])
      end
      it 'ned_planning_items' do
        expect(controller.ned_planning_items).to eq([ned_planning_item])
      end
    end

    describe 'templates' do
      render_views

      it 'responds with success and renders views without errors' do
        expect(response).to be_success
        expect(response).to render_template('shared/transparency/expenses/neds/show')
        expect(response).to render_template('shared/transparency/expenses/neds/show/_ned_items')
      end
    end
  end
end
