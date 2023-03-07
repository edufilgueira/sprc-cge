require 'rails_helper'

describe OpenData::DataSet::Search do
  it { is_expected.to be_searchable_like('open_data_data_sets.title') }
  it { is_expected.to be_searchable_like('open_data_data_sets.description') }
  it { is_expected.to be_searchable_like('integration_supports_organs.sigla') }
  it { is_expected.to be_searchable_like('integration_supports_organs.descricao_orgao') }

  it 'search_scope' do
    expected = OpenData::DataSet.includes(:organ).references(:organ)
    expect(OpenData::DataSet.search_scope).to eq(expected)
  end
end
