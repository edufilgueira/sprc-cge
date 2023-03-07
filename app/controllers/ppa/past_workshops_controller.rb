#
# Controlador para as oficinas de elaboração (realizados) do PPA
#
module PPA
  class PastWorkshopsController < ::PPAController
    include PastWorkshops::BaseBreadcrumbs
    include ::PaginatedController

    helper_method :past_workshops

    private

    def resource_klass
      PPA::Workshop
    end

    def past_workshops
      paginated(filtered_workshops)
    end

    def filtered_workshops
      results = current_plan.workshops.finished_until(params[:end_at])
      results = results.in_city(params[:city_id]) unless params[:city_id].blank?
      results
    end

  end
end
