class Platform::Tickets::ChangeTypesController < PlatformController
  include Platform::Tickets::ChangeTypes::Breadcrumbs
  include ::Tickets::ChangeTypes::BaseController
end
