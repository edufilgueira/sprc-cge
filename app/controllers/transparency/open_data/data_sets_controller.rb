class Transparency::OpenData::DataSetsController < TransparencyController
  include ::PaginatedController
  include ::SortedController
  include ::FilteredController
  include Transparency::OpenData::DataSets::Breadcrumbs

  SORT_COLUMNS = {
    title: 'open_data_data_sets.title',
    author: 'open_data_data_sets.author',
    organ: 'integration_supports_organs.sigla',
    source_catalog: 'open_data_data_sets.source_catalog'
  }

  FILTERED_ASSOCIATIONS = [
    :data_set_vcge_categories
  ]

  FILTERED_COLUMNS = [
   'open_data_data_set_vcge_categories.open_data_vcge_category_id'
  ]

  helper_method [:data_sets, :data_set, :transparency_id]

  # Helper methods

  def data_sets
    paginated_resources
  end

  def data_set
    resource
  end

  private

  def resource_klass
    ::OpenData::DataSet
  end

  def filtered_scope
    resource_klass.left_joins(:data_set_vcge_categories).distinct.order(default_sort_column)
  end

  def transparency_id
    :open_data_dataset
  end

  def default_sort_column
    'open_data_data_sets.title'
  end
end
