# Shared example para action index de controllers em transparency/tickets/public_tickets

shared_examples_for 'controllers/transparency/public_tickets/index' do
  describe '#index' do
    it_behaves_like 'controllers/base/index'
  end
end
