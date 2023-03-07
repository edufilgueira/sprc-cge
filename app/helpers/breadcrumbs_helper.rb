module BreadcrumbsHelper

  def render_breadcrumbs(breadcrumbs)
    render('shared/breadcrumbs', breadcrumbs: breadcrumbs)
  end

end
