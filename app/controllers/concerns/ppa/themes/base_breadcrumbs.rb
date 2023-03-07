module PPA
  module Themes    
    module BaseBreadcrumbs
      extend ActiveSupport::Concern
      include ::PPA::BaseBreadcrumbs

      protected

      def index_breadcrumbs
        [
          home_breadcrumb,
          thematic_proposition_breadcrumb,
          themes_breadcrumb
        ]
      end

      private

      def thematic_proposition_breadcrumb
        [t("#{namespace}.breadcrumbs.proposal_themes.index.title"), 
          url_for([:ppa, :root, only_path: true]) ]
      end

      def themes_breadcrumb
        [t("#{namespace}.breadcrumbs.proposal_themes.index.themes")]
      end
    end
  end
end
