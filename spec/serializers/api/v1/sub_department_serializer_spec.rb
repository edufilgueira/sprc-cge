require 'rails_helper'

describe Api::V1::SubDepartmentSerializer do

  let(:sub_department) { create(:sub_department) }

  let(:sub_department_serializer) do
    Api::V1::SubDepartmentSerializer.new(sub_department)
  end

  subject(:json) do
    sub_department_serializer.to_h
  end

  describe 'attributes' do
    it { expect(json[:id]).to eq(sub_department.id) }
    it { expect(json[:name]).to eq(sub_department.title) }
  end

end
