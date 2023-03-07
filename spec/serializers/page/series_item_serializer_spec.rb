require 'rails_helper'

describe Page::SeriesItemSerializer do
  let(:series_item) { create(:page_series_item) }

  let(:series_item_serializer) do
    Page::SeriesItemSerializer.new(series_item)
  end

  subject(:series_item_json) do
    series_item_serializer.to_h
  end

  describe 'attributes' do
    it { expect(series_item_json[:name]).to eq(series_item.title) }
    it { expect(series_item_json[:y]).to eq(series_item.value) }
  end

end
