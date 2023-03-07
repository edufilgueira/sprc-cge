require 'rails_helper'

describe Admin::ThemesController do
  let(:user) { create(:user, :admin) }

  let(:resources) { create_list(:theme, 1) }

  let(:permitted_params) do
    [
      :name,
      :code
    ]
  end

  let(:valid_params) { { theme: attributes_for(:theme) } }

  let(:sort_columns) do
    {
      code: 'themes.code',
      name: 'themes.name'
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
