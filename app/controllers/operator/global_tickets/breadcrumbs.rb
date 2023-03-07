module Operator::GlobalTickets::Breadcrumbs

  def index_breadcrumbs
    [
      operator_home_breadcrumb,
      [t('operator.global_tickets.index.title'), '']
    ]
  end


  # private

  private

  def operator_home_breadcrumb
    [ t('operator.home.index.title'), operator_root_path ]
  end
end
