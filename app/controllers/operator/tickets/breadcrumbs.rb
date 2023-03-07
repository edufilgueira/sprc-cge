module Operator::Tickets::Breadcrumbs
  include ::Tickets::BaseBreadcrumbs

  private

  def home_breadcrumb
    [ t('operator.home.index.title'), operator_root_path ]
  end
end
