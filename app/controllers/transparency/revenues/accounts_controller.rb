class Transparency::Revenues::AccountsController < TransparencyController
  include Transparency::Revenues::Accounts::BaseController
  include Transparency::Revenues::Accounts::Breadcrumbs
  include Transparency::RevenuesHelper
end
