module MobileApps::BaseBreadcrumbs

  protected

  def index_breadcrumbs
    [
      bradcrumb_home,
      [t('.title'), '']
    ]
  end

  private

  def bradcrumb_home
    [t("#{namespace}.home.index.title"), url_for([namespace, :root, only_path: true])]
  end
end
