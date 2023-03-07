class Operator::Tickets::ReopenTicketsController < OperatorController
  include ::Tickets::Reopens::BaseController
  include Operator::Tickets::ReopenTickets::Breadcrumbs

end
