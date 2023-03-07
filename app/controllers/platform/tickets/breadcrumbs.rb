module Platform::Tickets::Breadcrumbs
  include ::Tickets::BaseBreadcrumbs

  private

  def home_breadcrumb
    [ t('platform.home.index.title'), platform_root_path ]
  end
end
