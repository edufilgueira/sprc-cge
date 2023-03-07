require 'rails_helper'

describe Page::ChartSerializer do
  let(:chart) { create(:page_chart) }

  let(:chart_serializer) do
    Page::ChartSerializer.new(chart)
  end

  subject(:chart_json) do
    chart_serializer.to_h
  end

  describe 'attributes' do
    it { expect(chart_json[:id]).to eq(chart.id) }
    it { expect(chart_json[:title]).to eq(chart.title) }
    it { expect(chart_json[:description]).to eq(chart.description) }
    it { expect(chart_json[:unit]).to eq(chart.unit) }
    it { expect(chart_json[:series]).to eq([]) }
  end

end
