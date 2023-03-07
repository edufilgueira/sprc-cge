require 'rails_helper'

describe Transparency::OpenData::DataSetsController do

  let(:resources) { create_list(:data_set, 1) }

  it_behaves_like 'controllers/base/index' do
    let(:sort_columns) do
      {
        title: 'open_data_data_sets.title',
        author: 'open_data_data_sets.author',
        organ: 'integration_supports_organs.sigla',
        source_catalog: 'open_data_data_sets.source_catalog'
      }
    end

    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/search'
    it_behaves_like 'controllers/base/index/sorted'

    it_behaves_like 'controllers/base/index/xhr'
  end

  it_behaves_like 'controllers/base/show'
end
