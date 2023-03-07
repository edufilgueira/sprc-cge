module PPA
  module Themes
    module RegionalStrategies::BaseBreadcrumbs
      extend ActiveSupport::Concern
      include PPA::BaseBreadcrumbs

      protected

      def index_breadcrumbs
        [
          home_breadcrumb,
          region_with_biennium_breadcrumb,
          axis_breadcrumb,
          theme_breadcrumb
        ]
      end

      def show_edit_update_breadcrumbs
        [
          home_breadcrumb,
          region_with_biennium_breadcrumb,
          axis_breadcrumb,
          theme_breadcrumb,
          strategy_breadcrumb
        ]
      end

      private

      def theme_breadcrumb
        [theme.name, ppa_scoped_path(:theme_regional_strategies, theme)]
      end

      def strategy_breadcrumb
        # FIXME: essa sem o if a index estoura dizendo que não consegue
        # encontrar a estratégia regional, mas esse método não deveria
        # ser chamado na index
        text = params[:id] ? regional_strategy.strategy_name : ''
        [text, '']
      end

      def axis_breadcrumb
        [theme.axis.name, ppa_scoped_path(:axes)]
      end

      def home_breadcrumb
        [breadcrumb_key('home.show.title'), ppa_root_path]
      end

    end
  end
end
