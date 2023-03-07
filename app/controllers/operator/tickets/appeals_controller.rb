class Operator::Tickets::AppealsController < OperatorController
  include ::Tickets::Appeals::BaseController
  include Operator::Tickets::Appeals::Breadcrumbs

end
