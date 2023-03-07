class Transparency::Tickets::StatsTicketsController < TransparencyController
  include ::Reports::StatsTickets::BaseController
  include Transparency::Tickets::StatsTickets::Breadcrumbs

end
