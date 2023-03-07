module Operator::CallCenterTickets::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [ t('operator.home.index.title'), operator_root_path ],
      [ t("operator.call_center_tickets.index.title"), '' ]
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [ t('operator.home.index.title'), operator_root_path ],
      [ t("operator.call_center_tickets.index.title"), operator_call_center_tickets_path ],
      [ ticket.title, '' ]
    ]
  end

end
