module PPA::Themes
  class ProposalsController < PPAController
    include PPA::RegionWithBiennium
    include PPA::Themes::Proposals::BaseBreadcrumbs

    include ::PaginatedController
    include ::SortedController
    include ::FilteredController

    SORT_COLUMNS = {
      strategy:    'ppa_proposals.strategy',
      user:        'users.name',
      created_at:  'ppa_proposals.created_at',
      votes_count: 'ppa_proposals.votes_count'
    }

    helper_method :axis, :theme, :proposals

    private

    def proposals
      paginated(
        filtered_resources
          .sorted(sort_column, sort_direction)
      )
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
      theme.proposals.in_biennium_and_region(current_biennium, current_region)
    end

    def resource_klass
      PPA::Proposal
    end

  end
end
