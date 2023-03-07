class Admin::EventsController < Admin::BaseCrudController
  include Admin::Events::Breadcrumbs

  PERMITTED_PARAMS = [
    :title,
    :starts_at,
    :category,
    :description
  ]

  SORT_COLUMNS = {
    title: 'events.event',
    starts_at: 'events.starts_at'
  }

  helper_method [:events, :event]

  # Helper methods

  def events
    paginated_resources
  end

  def event
    resource
  end
end
