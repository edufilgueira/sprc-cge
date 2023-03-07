require 'rails_helper'

describe Admin::OpenData::DataSetsController do

  let(:user) { create(:user, :admin) }

  let(:resources) { create_list(:data_set, 1) }

  let(:permitted_params) do
    [
      :title,
      :description,
      :source_catalog,
      :organ_id,
      :author,

      data_items_attributes: [
        :id, :_destroy,
        :title,
        :description,
        :data_item_type,

        :response_path,
        :wsdl,
        :parameters,
        :operation,
        :headers_soap_action,
        :status,
        :document_public_filename,
        :document_format,
        :document
      ],

      data_set_vcge_categories_attributes: [
        :id, :_destroy,

        :open_data_vcge_category_id
      ]
    ]
  end

  let(:valid_params) do
    params = { data_set: attributes_for(:data_set) }

    params[:data_set][:organ_id] = create(:executive_organ).id

    params
  end

  let(:sort_columns) do
    {
      title: 'open_data_data_sets.title',
      author: 'open_data_data_sets.author',
      organ: 'integration_supports_organs.sigla',
      source_catalog: 'open_data_data_sets.source_catalog'
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

  it 'imports data_item' do
    sign_in(user)

    data_set = resources.first

    allow_any_instance_of(OpenData::DataItem).to receive(:import).and_return(nil)

    data_item = create(:data_item, data_set: data_set)

    expect_any_instance_of(OpenData::DataItem).to receive(:import)

    patch(:import, params: { id: data_set.id, data_item_id: data_item.id })

    expect(response).to redirect_to(admin_open_data_data_set_path(data_set))
  end
end
