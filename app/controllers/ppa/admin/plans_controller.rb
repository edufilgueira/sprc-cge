module PPA::Admin
  class PlansController < PPA::AdminController
    include Plans::BaseBreadcrumbs

    PERMITTED_PARAMS = [
      :start_year,
      :end_year,
      :status
    ]

    helper_method [:ppa_plans, :ppa_plan]

    # Helper methods

    def ppa_plans      
      paginated(resources.sorted)
    end

    def ppa_plan     
      resource
    end

    private

    def resource_name      
      'ppa_plan'
    end

    def resource_klass      
      PPA::Plan
    end

  end
end
