module PPA::Admin
  class VotingsController < PPA::AdminController
    include Votings::BaseBreadcrumbs

    PERMITTED_PARAMS = [
      :start_in,
      :end_in,
      :plan_id,
      :region_id
    ]

    helper_method [:ppa_votings, :ppa_voting]

    # Helper methods

    def ppa_votings
      paginated(resources.sorted)
    end

    def ppa_voting
      resource
    end

    private

    def resource_name
      'ppa_voting'
    end

    def resource_klass
      PPA::Voting
    end

  end
end
