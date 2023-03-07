module PPA
  module RegionalInitiatives::BaseBreadcrumbs
    extend ActiveSupport::Concern

    include PPA::BaseBreadcrumbs

    protected

    def show_edit_update_breadcrumbs
      [
        home_breadcrumb,
        region_with_biennium_breadcrumb,
        axis_breadcrumb,
        theme_breadcrumb,
        strategy_breadcrumb,
        [ regional_initiative.name, '' ]
      ]
    end

    private

    def theme_breadcrumb
      [
        theme.name,
        ppa_scoped_path(:theme_regional_strategies, theme)
      ]
    end

    def strategy_breadcrumb
      [
        regional_strategy.strategy_name,
        ppa_scoped_path(:theme_regional_strategy, theme, regional_strategy)
      ]
    end

    def axis_breadcrumb
      [
        theme.axis.name,
        ppa_scoped_path(:axes)
      ]
    end

    def home_breadcrumb
      [breadcrumb_key('home.show.title'), ppa_root_path]
    end

  end
end
