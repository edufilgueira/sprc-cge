class BaseCrudController < ApplicationController
  include ::PaginatedController
  include ::SortedController
  include ::FilteredController

end
