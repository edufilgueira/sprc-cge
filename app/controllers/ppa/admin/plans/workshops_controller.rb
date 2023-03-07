module PPA::Admin::Plans
  class WorkshopsController < PPA::AdminController
    include PPA::Admin::Plans::Workshops::BaseBreadcrumbs
    PERMITTED_PARAMS = [
      :link,
      :name,
      :start_at,
      :end_at,
      :address,
      :city_id,
      :participants_count,
      documents_attributes: [ :attachment, :_destroy, :id ],
      photos_attributes: [ :attachment, :_destroy, :id ],
    ]

    FILTERED_COLUMNS = [
      :name,
      :start_at
    ]

    SORT_COLUMNS = {
      name: 'ppa_workshops.name',
      start_at: 'ppa_workshops.start_at',
    }

    helper_method [:ppa_workshops, :ppa_workshop, :plan, :regions]

    # Helper methods

    def ppa_workshops
      paginated_resources
    end

    def ppa_workshop
      resource
    end

    def plan
      PPA::Plan.find(params[:plan_id])
    end

    def regions
      PPA::Region.all
    end

    private

    def resources
      plan.workshops
    end

    def resource_name
      'ppa_workshop'
    end

    def resource_klass
      PPA::Workshop
    end

  end
end
