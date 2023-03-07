class Admin::Integrations::MacroregionInvestimentsController < AdminController
  include Transparency::MacroregionInvestiments::BaseController
  include Admin::Integrations::MacroregionInvestiments::Breadcrumbs

end
