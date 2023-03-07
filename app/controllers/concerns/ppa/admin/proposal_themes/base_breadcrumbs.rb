module PPA::Admin
  module ProposalThemes::BaseBreadcrumbs
    extend ActiveSupport::Concern

    protected

    def index_breadcrumbs
      [
        home_breadcrumb,
        [ breadcrumb_key('proposal_themes.index.title'), "" ]
      ]
    end

    def new_create_breadcrumbs
      [
        home_breadcrumb,
        plans_home_breadcrumb,
        [ breadcrumb_key("proposal_themes.#{action_name}.title"), "" ]
      ]
    end

    def show_edit_update_breadcrumbs
      [
        home_breadcrumb,
        plans_home_breadcrumb,
        [ ppa_proposal_theme.start_in.to_s, "" ]
      ]
    end

    private

    def home_breadcrumb
      [ breadcrumb_key('home.index.title'), url_for([:ppa_admin, :root, only_path: true]) ]
    end

    def plans_home_breadcrumb
      [ breadcrumb_key('plans.index.title'), url_for([:ppa_admin, :proposal_themes, only_path: true]) ]
    end

    def breadcrumb_key(key)
      t("ppa.admin.breadcrumbs.#{key}")
    end

  end
end
