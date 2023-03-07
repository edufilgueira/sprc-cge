require 'rails_helper'

describe Admin::RedeOuvirOrgansController do

  let(:user) { create(:user, :admin) }

  let(:resources) { create_list(:rede_ouvir_organ, 1) }

  let(:permitted_params) do
    [
      :name,
      :acronym,
      :description,
      :code,
      :subnet,
      :ignore_cge_validation
    ]
  end

  let(:valid_params) { { rede_ouvir_organ: attributes_for(:rede_ouvir_organ) } }

  let(:sort_columns) do
    {
      acronym: 'organs.acronym',
      name: 'organs.name'
    }
  end

  it_behaves_like 'controllers/admin/base/index' do
    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/search'
    it_behaves_like 'controllers/base/index/sorted'
    it_behaves_like 'controllers/admin/base/index/xhr'
    it_behaves_like 'controllers/admin/base/index/filter_disabled'
  end

  it_behaves_like 'controllers/admin/base/new' do
    it 'defaults ignore_cge_validation to true' do
      get(:new)

      expect(controller.rede_ouvir_organ).to be_ignore_cge_validation
    end
  end

  it_behaves_like 'controllers/admin/base/create'
  it_behaves_like 'controllers/admin/base/show'
  it_behaves_like 'controllers/admin/base/edit'
  it_behaves_like 'controllers/admin/base/update'
  it_behaves_like 'controllers/admin/base/toggle_disabled'
end
