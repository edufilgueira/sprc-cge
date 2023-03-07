require 'rails_helper'

describe GlobalSearcher::Base do
	let(:search_term) {'Avaliação'}
	let(:service) { GlobalSearcher::Base.new(:search_term) }

	describe 'self.call' do
		it 'initialize and invoke call method' do
			clone_service = double
			allow(GlobalSearcher::Base).to receive(:new) { clone_service }
			allow(clone_service).to receive(:call)

			GlobalSearcher::Base.call(:search_term)
			
			expect(GlobalSearcher::Base).to have_received(:new).with(:search_term)
			expect(clone_service).to have_received(:call)
		end
	end
end