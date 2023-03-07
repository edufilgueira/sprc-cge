class Transparency::Contracts::ConvenantsController < TransparencyController
  include Transparency::Contracts::Convenants::BaseController
  include Transparency::Contracts::Convenants::Breadcrumbs
  include Transparency::Contracts::Instrument

end
