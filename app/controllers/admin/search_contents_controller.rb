class Admin::SearchContentsController < Admin::BaseCrudController
  include Admin::SearchContents::Breadcrumbs

  PERMITTED_PARAMS = [
    :title,
    :content,
    :description,
    :link
  ]

  SORT_COLUMNS = {
    title: 'search_contents.title',
    content: 'search_contents.content',
    link: 'search_contents.link'
  }

  helper_method [:search_contents, :search_content]

  # precisa guardar o `title`, pois em actions como o :destroy após
  # remover não é possível acessar o atributo que fica associado com as :translations
  before_action :store_title, only: :destroy

  # Helper methods

  def search_contents
    paginated_resources
  end

  def search_content
    resource
  end

  private

  def resource_notice_title
    @title || super
  end

  def store_title
    @title = resource.title
  end
end
