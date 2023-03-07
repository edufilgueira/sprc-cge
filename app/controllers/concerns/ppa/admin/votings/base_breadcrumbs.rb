module PPA::Admin
  module Votings::BaseBreadcrumbs
    extend ActiveSupport::Concern

    protected

    def index_breadcrumbs
      [
        home_breadcrumb,
        [ breadcrumb_key('votings.index.title'), "" ]
      ]
    end

    def new_create_breadcrumbs
      [
        home_breadcrumb,
        plans_home_breadcrumb,
        [ breadcrumb_key("votings.#{action_name}.title"), "" ]
      ]
    end

    def show_edit_update_breadcrumbs
      [
        home_breadcrumb,
        plans_home_breadcrumb,
        # [ ppa_plan.start_year.to_s, "" ]
      ]
    end

    private

    def home_breadcrumb
      [ breadcrumb_key('home.index.title'), url_for([:ppa_admin, :root, only_path: true]) ]
    end

    def plans_home_breadcrumb
      [ breadcrumb_key('votings.index.title'), url_for([:ppa_admin, :votings, only_path: true]) ]
    end

    def breadcrumb_key(key)
      t("ppa.admin.breadcrumbs.#{key}")
    end

  end
end