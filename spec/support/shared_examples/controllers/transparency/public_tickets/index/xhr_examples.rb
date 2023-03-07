# Shared example para action index com ajax de base controllers em admin

shared_examples_for 'controllers/transparency/public_tickets/index/xhr' do
  describe '#index' do
    it_behaves_like 'controllers/base/index/xhr'
  end
end
