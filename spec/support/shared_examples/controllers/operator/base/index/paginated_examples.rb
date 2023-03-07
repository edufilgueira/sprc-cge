shared_examples_for 'controllers/operator/base/index/paginated' do
  describe '#index' do
    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/base/index/paginated'
    end
  end
end
