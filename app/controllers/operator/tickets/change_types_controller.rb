class Operator::Tickets::ChangeTypesController < OperatorController
  include Operator::Tickets::ChangeTypes::Breadcrumbs
  include ::Tickets::ChangeTypes::BaseController
end
