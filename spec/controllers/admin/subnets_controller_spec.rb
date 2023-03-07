require 'rails_helper'

describe Admin::SubnetsController do

  let(:user) { create(:user, :admin) }

  let(:resources) { create_list(:subnet, 1) }

  let(:subnet) { resources.first }

  let(:permitted_params) do
    [
      :name,
      :acronym,
      :organ_id,
      :ignore_sectoral_validation
    ]
  end

  let(:valid_params) do
    attrs = attributes_for(:subnet)
    attrs[:organ_id] = create(:executive_organ).id

    { subnet: attrs }
  end

  let(:sort_columns) do
    {
      organ_acronym: 'organs.acronym',
      acronym: 'subnets.acronym',
      name: 'subnets.name'
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
