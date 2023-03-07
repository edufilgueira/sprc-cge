module Admin::UnregistredCitizens::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      home_breadcrumb,
      [ t("admin.unregistred_citizens.index.title"), "" ]
    ]
  end

  def show_edit_update_breadcrumbs
    [
      home_breadcrumb,
      unregistred_citizens_home_breadcrumb,
      [ ticket.name, "" ]
    ]
  end

  private

  def home_breadcrumb
    [ t("admin.home.index.title"), admin_root_path ]
  end

  def unregistred_citizens_home_breadcrumb
    [ t("admin.unregistred_citizens.index.title"), admin_unregistred_citizens_path ]
  end
end
