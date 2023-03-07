module PPA::Admin
  class ProposalThemesController < PPA::AdminController
    include ProposalThemes::BaseBreadcrumbs

    PERMITTED_PARAMS = [
      :start_in,
      :end_in,
      :plan_id,
      :region_id    
    ]

    helper_method [:ppa_proposal_themes, :ppa_proposal_theme]

    # Helper methods

    def ppa_proposal_themes
       paginated(resources.sorted)
    end

    def ppa_proposal_theme   
      resource
    end
   
    private   

    def resource_name   
      'ppa_proposal_theme'
    end

    def resource_klass
      PPA::ProposalTheme
    end

  end
end
