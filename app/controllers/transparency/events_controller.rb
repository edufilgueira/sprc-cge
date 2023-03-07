class Transparency::EventsController < TransparencyController
  include Transparency::BaseController
  include Transparency::Events::Breadcrumbs

  FILTERED_DATE_RANGE = [
    :starts_at
  ]

  PER_PAGE = 9

  helper_method [ :events, :event ]

  # Helper methods

  def events
    paginated_resources
  end

  def event
    resource
  end

  def sorted_resources
    resource_klass.order(starts_at: :asc)
  end

  private

  def transparency_id
    :events
  end
end
