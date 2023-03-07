class Operator::Reports::StatsTicketsController < OperatorController
  include ::Reports::StatsTickets::BaseController
  include Operator::Reports::StatsTickets::Breadcrumbs

end
