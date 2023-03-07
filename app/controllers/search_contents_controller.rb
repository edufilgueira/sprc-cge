class SearchContentsController < BaseCrudController
  include SearchContents::Breadcrumbs

  PERMITTED_PARAMS = [
    :title,
    :content,
    :link
  ]

  SORT_COLUMNS = {
    title: 'search_contents.title',
    content: 'search_contents.content',
    link: 'search_contents.link'
  }

  helper_method [:search_contents]

  # Helper methods

  def search_contents
    if params_search.blank?
      SearchContent.none
    else
      paginated_resources
    end
  end

  # Privates

  private

  def params_search
    params[:search]
  end
end
