module Users::BaseBreadcrumbs
  extend ActiveSupport::Concern

  protected

  def index_breadcrumbs
    [
      home_breadcrumb,
      [ t("#{namespace}.users.index.title"), "" ]
    ]
  end

  def new_create_breadcrumbs
    [
      home_breadcrumb,
      users_home_breadcrumb,
      [ t("#{namespace}.users.#{action_name}.title"), "" ]
    ]
  end

  def show_edit_update_breadcrumbs
    [
      home_breadcrumb,
      users_home_breadcrumb,
      [ user.title, "" ]
    ]
  end

  private

  def home_breadcrumb
    [ t("#{namespace}.home.index.title"), url_for([namespace, :root, only_path: true]) ]
  end

  def users_home_breadcrumb
    [ t("#{namespace}.users.index.title"), url_for([namespace, :users, only_path: true]) ]
  end
end
