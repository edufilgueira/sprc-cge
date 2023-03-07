class Operator::BaseCrudController < OperatorController
  include ::PaginatedController
  include ::SortedController
  include ::FilteredController

end
