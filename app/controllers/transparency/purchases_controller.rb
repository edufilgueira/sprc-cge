class Transparency::PurchasesController < TransparencyController
  include Transparency::Purchases::BaseController
  include Transparency::Purchases::Breadcrumbs
end
