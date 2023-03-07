module Transparency::Sou::Ombudsmen::BaseController
  extend ActiveSupport::Concern
  include ::PaginatedController
  include ::SortedController
  include ::FilteredController
  include Transparency::Sou::Ombudsmen::Breadcrumbs

end
