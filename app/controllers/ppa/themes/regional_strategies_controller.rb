module PPA::Themes
  class RegionalStrategiesController < PPAController
    include PPA::RegionWithBiennium
    include PPA::Themes::RegionalStrategies::BaseBreadcrumbs

    include ::PaginatedController
    include ::SortedController
    include ::FilteredController


    SORT_COLUMNS = {
      objectives:          'ppa_objectives.name',
      strategies:          'ppa_strategies.name',
      priority:            'ppa_biennial_regional_strategies.priority_index',
      initiatives_count:   'ppa_biennial_regional_strategies.initiatives_count',
      products_count:      'ppa_biennial_regional_strategies.products_count',
    }

    helper_method :axis, :theme, :regional_strategies, :regional_strategy, :proposals

    def proposals
      @proposals ||= theme.proposals
        .in_biennium_and_region(current_biennium, current_region)
    end

    private

    def regional_strategies
      paginated(
        filtered_resources
          .sorted(sort_column, sort_direction)
      )
    end

    def regional_strategy
      @regional_strategy ||= resource_klass.find(params[:id])
    end

    def axis
      @axis ||= theme.axis
    end

    def theme
      @theme ||= PPA::Theme.find(params[:theme_id])
    end

    def filtered_resources
      filtered_scope.search(params[:search], nil, expression(resource_klass))
    end

    def filtered_scope
      theme.biennial_regional_strategies.in_biennium_and_region(current_biennium, current_region)
    end

    def resource_klass
      PPA::Biennial::RegionalStrategy
    end

  end
end
