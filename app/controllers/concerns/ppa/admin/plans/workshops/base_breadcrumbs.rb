module PPA::Admin::Plans
  module Workshops::BaseBreadcrumbs
    extend ActiveSupport::Concern

    protected

    def index_breadcrumbs
      [
        home_breadcrumb,
        plans_home_breadcrumb,
        plan_breadcrumb,
        [ breadcrumb_key('workshops.index.title'), "" ]
      ]
    end

    def new_create_breadcrumbs
      [
        home_breadcrumb,
        plans_home_breadcrumb,
        plan_breadcrumb,
        workshops_home_breadcrumb,
        [ breadcrumb_key("workshops.#{action_name}.title"), "" ]
      ]
    end

    def show_edit_update_breadcrumbs
      [
        home_breadcrumb,
        plans_home_breadcrumb,
        plan_breadcrumb,
        workshops_home_breadcrumb,
        [ ppa_workshop.name, "" ]
      ]
    end

    private


    def home_breadcrumb
      [ breadcrumb_key('home.index.title'), url_for([:ppa_admin, :root, only_path: true]) ]
    end

    def plans_home_breadcrumb
      [ breadcrumb_key('plans.index.title'), url_for([:ppa_admin, :plans, only_path: true]) ]
    end

    def plan_breadcrumb
      [ plan.start_year.to_s, ppa_admin_plan_path(plan) ]
    end

    def workshops_home_breadcrumb
      [ breadcrumb_key('workshops.index.title'), url_for([:ppa_admin, :plan, :workshops, only_path: true]) ]
    end

    def breadcrumb_key(key)
      t("ppa.admin.breadcrumbs.#{key}")
    end

  end
end
