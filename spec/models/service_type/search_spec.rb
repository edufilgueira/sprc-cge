require 'rails_helper'

describe ServiceType::Search do
  let!(:service_type) { create(:service_type) }

  it 'by name' do
    service_type = create(:service_type, name: 'Ouvidoria')
    service_types = ServiceType.search(service_type.name)

    expect(service_types).to eq([service_type])
  end

  it 'by code' do
    service_type = create(:service_type, code: '747')
    service_types = ServiceType.search(service_type.code)

    expect(service_types).to eq([service_type])
  end

  it 'by organ' do
    organ = create(:executive_organ)
    service_type = create(:service_type, organ: organ)
    service_types = ServiceType.search(service_type.organ_acronym)

    expect(service_types).to eq([service_type])
  end
end
