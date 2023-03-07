#
# Classe base para buscadores globais
#
class GlobalSearcher::Base
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::SanitizeHelper

  SEARCH_LIMIT = 5

  DESCRIPTION_TRUNCATE_SIZE = 200

  attr_reader :search_term, :original_configuration

  def self.call(search_term)
    new(search_term).call
  end

  def initialize(search_term)
    @search_term = search_term
    @original_configuration = model_klass.connection_config.dup
  end

  def call
    search_results
  end

  private

  def search_results
    results = limited_results.map do |result|
      search_result(result)
    end

    { id: model_klass.name, results: results, show_more_url: show_more_url }
  end

  def show_more_url_params
    { search: search_term, anchor: 'search' }.merge(locale_params)
  end

  def locale_params
    { locale: I18n.locale }
  end

  def limited_results
    base_results.limit(self.class::SEARCH_LIMIT)
  end

  def base_results
    translation_class.present? ? send("query_#{translation_class.table_name}") : model_class_search
  end

  def query_default
    model_class_search.joins(:translations).where(translation_query)
  end

  def model_class_search
    model_klass.search(search_term)
  end

  def query_page_translations
    query_default.where(status: :active)
  end

  def query_search_content_translations
    query_default
  end

  def translation_query
    "#{translation_class.table_name}.locale = '#{I18n.locale}'"
  end

  def translation_class
    model_klass.try(:translation_class)
  end

  def description_truncate_size
    self.class::DESCRIPTION_TRUNCATE_SIZE
  end
end
