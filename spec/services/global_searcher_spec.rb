require 'rails_helper'

describe GlobalSearcher do

  let(:url_helper) do
    Rails.application.routes.url_helpers
  end

  describe 'self.call' do
    let(:service) { GlobalSearcher.new }

    it 'initialize and invoke call method with param' do
      service = double
      allow(GlobalSearcher).to receive(:new) { service }
      allow(service).to receive(:call)
      GlobalSearcher.call(:search_content, 'abc')

      expect(GlobalSearcher).to have_received(:new).with(:search_content, 'abc')
      expect(service).to have_received(:call)
    end
  end
end
