require 'rails_helper'

describe Admin::ServiceTypesController do

  let(:user) { create(:user, :admin) }

  let(:resources) { create_list(:service_type, 1) }

  let(:service_type) { resources.first }

  let(:permitted_params) do
    [
      :name,
      :organ_id,
      :code,
      :subnet_id
    ]
  end

  let(:valid_params) do
    attrs = attributes_for(:service_type)
    attrs[:organ_id] = create(:executive_organ).id

    { service_type: attrs }
  end

  let(:sort_columns) do
    {
      organ_acronym: 'organs.acronym',
      name: 'service_types.name',
      code: 'service_types.code'
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
  it_behaves_like 'controllers/admin/base/show'
  it_behaves_like 'controllers/admin/base/edit'
  it_behaves_like 'controllers/admin/base/update'
  it_behaves_like 'controllers/admin/base/toggle_disabled'
end
