module PPA::Admin
  module Administrators::BaseBreadcrumbs
    extend ActiveSupport::Concern

    protected

    def index_breadcrumbs
      [
        home_breadcrumb,
        [ breadcrumb_key('administrators.index.title'), "" ]
      ]
    end

    def new_create_breadcrumbs
      [
        home_breadcrumb,
        administrators_home_breadcrumb,
        [ breadcrumb_key("administrators.#{action_name}.title"), "" ]
      ]
    end

    def show_edit_update_breadcrumbs
      [
        home_breadcrumb,
        administrators_home_breadcrumb,
        [ ppa_administrator.name, "" ]
      ]
    end

    private

    def home_breadcrumb
      [ breadcrumb_key('home.index.title'), url_for([:ppa_admin, :root, only_path: true]) ]
    end

    def administrators_home_breadcrumb
      [ breadcrumb_key('administrators.index.title'), url_for([:ppa_admin, :administrators, only_path: true]) ]
    end

    def breadcrumb_key(key)
      t("ppa.admin.breadcrumbs.#{key}")
    end

  end
end
