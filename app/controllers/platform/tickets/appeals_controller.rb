class Platform::Tickets::AppealsController < PlatformController
  include ::Tickets::Appeals::BaseController
  include Platform::Tickets::Appeals::Breadcrumbs

end
