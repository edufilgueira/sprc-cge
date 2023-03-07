# Shared example para action index com ajax de base controllers em admin

shared_examples_for 'controllers/admin/base/index/xhr' do
  describe '#index' do
    context 'unauthorized' do
      before { get(:index, xhr: true) }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/base/index/xhr'
    end
  end
end
