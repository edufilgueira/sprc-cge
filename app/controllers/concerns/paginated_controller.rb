#
# Módulo incluído em controllers que permitem paginação.
#
# Os controllers que incluem esse módulo podem sobrescrever as contantes:
#
# PER_PAGE (default: 20)
#
module PaginatedController
  extend ActiveSupport::Concern

  PER_PAGE = 20

  # Privates

  private

  def paginated_resources
    paginated(filtered_resources)
  end

  def paginated(resources)
    page = constrained_page(resources)
    resources.page(page).per(per_page)
  end

  def per_page
    params[:per_page].present? ? params[:per_page] : self.class::PER_PAGE
  end

  def total_pages(resources)
    resources.page(1).per(per_page).total_pages
  end

  def constrained_page(resources)
    page = params[:page].to_i
    total_pages = total_pages(resources)

    if page > total_pages
      params[:page] = total_pages
    end

    params[:page]
  end
end
