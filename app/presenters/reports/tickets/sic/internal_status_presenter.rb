class Reports::Tickets::Sic::InternalStatusPresenter < Reports::Tickets::InternalStatusBasePresenter
  private

  def internal_statuses
    Ticket.internal_statuses.except(:appeal, :cge_validation).keys
  end
end
