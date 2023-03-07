require 'rails_helper'

describe PageSerializer do
  let(:page) { create(:page) }

  let(:page_serializer) do
    PageSerializer.new(page)
  end

  subject(:page_json) do
    page_serializer.to_h
  end

  describe 'attributes' do
    it { expect(page_json[:id]).to eq(page.id) }
    it { expect(page_json[:page_charts]).to eq([]) }
  end

end
