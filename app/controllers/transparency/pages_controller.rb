class Transparency::PagesController < TransparencyController
  include ::PaginatedController
  include ::SortedController
  include ::FilteredController
  include ::Pages::BaseController
  include ::Transparency::Pages::Breadcrumbs

  PER_PAGE=1

  FIND_ACTIONS = FIND_ACTIONS + ['attachments']

  SORT_COLUMNS = {
    title: 'page_translations.title'
  }

  def sort_columns
    self.class::SORT_COLUMNS
  end

  private

  def params_search
    params[:search]
  end
end
