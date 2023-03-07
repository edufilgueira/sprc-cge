require 'rails_helper'

describe Admin::SearchContentsController do

  let(:user) { create(:user, :admin) }

  let(:resources) { create_list(:search_content, 1) }

  let(:permitted_params) do
    [
      :title,
      :content,
      :description,
      :link
    ]
  end

  let(:valid_params) { { search_content: attributes_for(:search_content) } }

  let(:sort_columns) do
    {
      title: 'search_contents.title',
      content: 'search_contents.content',
      link: 'search_contents.link'
    }
  end

  it_behaves_like 'controllers/admin/base/index' do
    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/search'
    it_behaves_like 'controllers/base/index/sorted'

    it_behaves_like 'controllers/admin/base/index/xhr'
  end

  it_behaves_like 'controllers/admin/base/new'
  it_behaves_like 'controllers/admin/base/create'
  it_behaves_like 'controllers/admin/base/show'
  it_behaves_like 'controllers/admin/base/edit'
  it_behaves_like 'controllers/admin/base/update'
  it_behaves_like 'controllers/admin/base/destroy'
end
