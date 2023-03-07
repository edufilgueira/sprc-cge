class PPA::PlansController < PPAController
  include PPA::Plans::Breadcrumbs

  helper_method [
    :last_workshop, 
    :cities, 
    :regions, 
    :regions_vote_schedule,
    :revision_schedule
  ]

  private

  def last_workshop
    return nil unless current_plan

    current_plan.workshops.finished_until(Date.yesterday.to_s).first
  end

  def cities
    PPA::City.all
  end

  def regions
    PPA::Region.all
  end

  def revision_schedule
    plan.revision_schedules.order(:start_in)
  end

  def regions_vote_schedule
    plan.votings.includes(:region).order('ppa_regions.name')
  end
end
