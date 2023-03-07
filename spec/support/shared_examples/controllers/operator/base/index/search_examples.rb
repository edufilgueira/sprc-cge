shared_examples_for 'controllers/operator/base/index/search' do
  describe '#index' do
    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/base/index/search'
    end
  end
end
