require 'rails_helper'

describe Page::SeriesDatumSerializer do
  let(:series_datum) { create(:page_series_datum) }

  let(:series_datum_serializer) do
    Page::SeriesDatumSerializer.new(series_datum)
  end

  subject(:series_datum_json) do
    series_datum_serializer.to_h
  end

  describe 'attributes' do
    it { expect(series_datum_json[:name]).to eq(series_datum.title) }
    it { expect(series_datum_json[:type]).to eq(series_datum.series_type) }
    it { expect(series_datum_json[:data]).to eq([]) }
  end

end
