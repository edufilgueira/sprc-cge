require 'rails_helper'

describe Api::V1::DepartmentsController do
  include ResponseSpecHelper

  let(:department) { create(:department) }

  describe '#index' do
    before { department && get(:index) }

    it { is_expected.to respond_with(:success) }
    it { expect(json[0]['id']).to eq department.id }
    it { expect(json[0]['name']).to eq department.short_title }

    describe 'filter' do
      it 'organ_id' do
        another_department = create(:department)

        get(:index, params: {'organ_id': department.organ.id})

        expect(json.length).to eq(1)
        expect(json[0]['id']).to eq(department.id)
      end

      it 'subnet_id' do
        subnet = create(:subnet)
        another_department = create(:department, subnet: subnet)

        get(:index, params: {'subnet_id': subnet.id})

        expect(json.length).to eq(1)
        expect(json[0]['id']).to eq(another_department.id)
      end
    end
  end
end
