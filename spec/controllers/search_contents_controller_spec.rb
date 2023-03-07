require 'rails_helper'

describe SearchContentsController do

  let(:resources) { create_list(:search_content, 1) }

  let(:search_content) { resources.first }

  let(:permitted_params) do
    [
      :title,
      :content,
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

  it_behaves_like 'controllers/base/index' do
    before do
      allow(controller).to receive(:params_search).and_return(search_content.content)
    end

    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/sorted'
    it_behaves_like 'controllers/base/index/search'
  end


  it 'returns none if not filtered' do
    get :index, params: { search: '' }

    expect(controller.search_contents).to eq(SearchContent.none)
  end
end
