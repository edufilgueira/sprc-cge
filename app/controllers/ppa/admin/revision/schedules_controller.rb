class PPA::Admin::Revision::SchedulesController < PPA::AdminController
  #include Schedules::BaseBreadcrumbs

  PERMITTED_PARAMS = [
    :start_in,
    :end_in,
    :plan_id,
    :stage
  ]

  helper_method [:ppa_revision_schedules, :ppa_revision_schedule, :resource_klass]

  # Helper methods

  def ppa_revision_schedules
    paginated(resources.sorted)
  end

  def ppa_revision_schedule
    resource
  end

  def resource_klass
    PPA::Revision::Schedule
  end
  
  private
  
  def resource_name
    'ppa_revision_schedule'
  end


end
