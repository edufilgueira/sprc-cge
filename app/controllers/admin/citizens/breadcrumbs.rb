module Admin::Citizens::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      home_breadcrumb,
      [ t("admin.citizens.index.title"), "" ]
    ]
  end

  def show_edit_update_breadcrumbs
    [
      home_breadcrumb,
      citizens_home_breadcrumb,
      [ user.title, "" ]
    ]
  end

  private

  def home_breadcrumb
    [ t("admin.home.index.title"), admin_root_path ]
  end

  def citizens_home_breadcrumb
    [ t("admin.citizens.index.title"), admin_citizens_path ]
  end
end
