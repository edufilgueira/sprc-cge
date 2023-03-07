module PPA::Themes::RegionalStrategies
  class RegionalInitiativesController < PPAController
    include PPA::RegionWithBiennium
    include PPA::RegionalInitiatives::BaseBreadcrumbs

    helper_method :axis, :theme, :regional_strategy, :regional_initiative

    private

    def regional_initiative
      @regional_initiative ||= regional_strategy.initiatives.find(params[:id])
    end

    def regional_strategy
      @regional_strategy ||= theme
        .biennial_regional_strategies
        .in_biennium_and_region(current_biennium, current_region)
        .find(params[:regional_strategy_id])
    end

    def axis
      @axis ||= theme.axis
    end

    def theme
      @theme ||= PPA::Theme.find(params[:theme_id])
    end

  end
end
