require 'rails_helper'

describe Admin::DepartmentsController do

  let(:user) { create(:user, :admin) }

  let(:resources) { create_list(:department, 1) }

  let(:department) { resources.first }

  let(:permitted_params) do
    [
      :name,
      :acronym,
      :organ_id,
      :subnet_id,
      sub_departments_attributes: [
        :id,
        :name,
        :acronym,
        :_disable
      ]
    ]
  end

  let(:valid_params) do
    attrs = attributes_for(:department)
    attrs[:organ_id] = create(:executive_organ).id

    { department: attrs }
  end

  let(:sort_columns) do
    {
      organ_acronym: 'organs.acronym',
      subnet_acronym: 'subnets.acronym',
      acronym: 'departments.acronym',
      name: 'departments.name'
    }
  end

  it_behaves_like 'controllers/admin/base/index' do
    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/search'
    it_behaves_like 'controllers/base/index/sorted'
    it_behaves_like 'controllers/admin/base/index/xhr'
    it_behaves_like 'controllers/admin/base/index/filter_disabled'
  end

  it_behaves_like 'controllers/admin/base/new'
  it_behaves_like 'controllers/admin/base/create'
  it_behaves_like 'controllers/admin/base/show' do
    describe 'helper methods' do
      before { sign_in(user) && get(:show, params: { id: department }) }

      it 'sub_departments' do
        create_list(:sub_department, 2, department: department)
        expect(controller.sub_departments).to eq(department.sub_departments.enabled)
      end
    end
  end

  it_behaves_like 'controllers/admin/base/edit'
  it_behaves_like 'controllers/admin/base/toggle_disabled'

  describe '#update' do
    it_behaves_like 'controllers/admin/base/update'

    context 'change field to nil' do

      before { sign_in(user) }

      let(:organ) { create(:executive_organ) }
      let(:subnet) { create(:subnet) }

      it 'subnet when update for organ' do
        valid_department = create(:department, :with_subnet)
        valid_department_params = valid_department.attributes
        valid_department_params.delete("subnet_id")
        valid_department_params["organ_id"] = organ.id

        patch(:update, params: { id: valid_department.id, department: valid_department_params} )

        valid_department.reload

        expect(valid_department.organ).not_to eq(nil)
        expect(valid_department.subnet).to eq(nil)
      end

      it 'subnet when update for organ' do
        valid_department = create(:department)
        valid_department_params = valid_department.attributes
        valid_department_params.delete("organ_id")
        valid_department_params["subnet_id"] = subnet.id

        patch(:update, params: { id: valid_department.id, department: valid_department_params , from_subnet: "1" })

        valid_department.reload

        expect(valid_department.organ).to eq(nil)
        expect(valid_department.subnet).not_to eq(nil)
      end
    end
  end
end
