class Admin::BaseCrudController < AdminController
  include ::PaginatedController
  include ::SortedController
  include ::FilteredController

end
