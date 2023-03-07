require 'rails_helper'

describe ServiceTypesHelper do
  let(:service_type) { create(:service_type) }

  context 'service_type_by_id_for_select' do
    it 'when filter is selected' do
      expected = [
        [service_type.title, service_type.id]
      ].sort.to_h

      expect(service_type_by_id_for_select(service_type.id)).to eq(expected)
    end

    it 'when filter is not selected' do
      expected = []

      expect(service_type_by_id_for_select(nil)).to eq(expected)
    end
  end
end
