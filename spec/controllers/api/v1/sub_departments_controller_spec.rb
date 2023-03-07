require 'rails_helper'

describe Api::V1::SubDepartmentsController do
  include ResponseSpecHelper

  let(:sub_department) { create(:sub_department) }

  describe '#index' do
    before { sub_department && get(:index) }

    it { is_expected.to respond_with(:success) }
    it { expect(json[0]['id']).to eq sub_department.id }
    it { expect(json[0]['name']).to eq sub_department.title }

    describe 'filter' do
      it 'department_id' do
        another_sub_department = create(:sub_department)

        get(:index, params: {'department_id': sub_department.department.id})

        expect(json.length).to eq(1)
        expect(json[0]['id']).to eq(sub_department.id)
      end
    end
  end
end
