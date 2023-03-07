require 'rails_helper'

describe Api::V1::DepartmentSerializer do

  let(:department) { create(:department) }

  let(:department_serializer) do
    Api::V1::DepartmentSerializer.new(department)
  end

  subject(:json) do
    department_serializer.to_h
  end

  describe 'attributes' do
    it { expect(json[:id]).to eq(department.id) }
    it { expect(json[:name]).to eq(department.short_title) }
  end

end
