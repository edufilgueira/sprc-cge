class Transparency::Contracts::ContractsController < TransparencyController
  include Transparency::Contracts::Contracts::BaseController
  include Transparency::Contracts::Contracts::Breadcrumbs
  include Transparency::Contracts::Instrument

end
