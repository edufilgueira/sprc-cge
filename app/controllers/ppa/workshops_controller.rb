#
# Controlador para as oficinas de elaboração (futuros) do PPA
#
module PPA
  class WorkshopsController < PPAController
    include Workshops::BaseBreadcrumbs
    include ::PaginatedController

    helper_method :workshops

    private

    def resource_klass
      PPA::Workshop
    end

    def workshops
      paginated(filtered_workshops)
    end

    def filtered_workshops
      results = current_plan.workshops.starting_at(params[:start_at])
      results = results.in_city(params[:city_id]) unless params[:city_id].blank?
      results
    end

  end
end
