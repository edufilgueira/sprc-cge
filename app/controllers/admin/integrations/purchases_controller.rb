class Admin::Integrations::PurchasesController < AdminController
  include Transparency::Purchases::BaseController
  include Admin::Integrations::Purchases::Breadcrumbs

end
