require 'rails_helper'

describe SubnetsHelper do
  it 'subnets_for_select' do
    create_list(:subnet, 2)

    subnets = Subnet.sorted
    expected = subnets.map do |subnet|
      ["[#{subnet.organ_acronym}] #{subnet.acronym} - #{subnet.name}", subnet.id]
    end

    expect(subnets_for_select).to eq(expected)
  end
  it 'subnets_by_organ_for_select' do
    subnets = create_list(:subnet, 2)

    subnet = subnets.first
    expected = [["[#{subnet.organ_acronym}] #{subnet.acronym} - #{subnet.name}", subnet.id]]

    expect(subnets_by_organ_for_select(subnet.organ)).to eq(expected)
  end
end
