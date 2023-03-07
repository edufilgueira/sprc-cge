class Admin::OpenData::DataSetsController < Admin::BaseCrudController
  include Admin::OpenData::DataSets::Breadcrumbs

  PERMITTED_PARAMS = [
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
      :document,
    ],

    data_set_vcge_categories_attributes: [
      :id, :_destroy,

      :open_data_vcge_category_id
    ]
  ]

  SORT_COLUMNS = {
    title: 'open_data_data_sets.title',
    author: 'open_data_data_sets.author',
    organ: 'integration_supports_organs.sigla',
    source_catalog: 'open_data_data_sets.source_catalog'
  }

  # Actions

  def import
    webservice_data_items.each do |data_item|
      data_item.import
    end

    redirect_to_show_with_success
  end

  helper_method [:data_sets, :data_set]

  # Helper methods

  def data_sets
    paginated_resources
  end

  def data_set
    resource
  end

  def webservice_data_items
    data_set.data_items.webservice
  end

  private

  def resource_klass
    ::OpenData::DataSet
  end

  def api_importer_id
    :open_data
  end
end
