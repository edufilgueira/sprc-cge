class Transparency::Sou::HomeController < TransparencyController
  include Transparency::Sou::Home::Breadcrumbs

  helper_method :upcoming_events

  def upcoming_events
    Event.upcoming.first(3)
  end
end
