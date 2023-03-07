class Reports::Tickets::Delayed::SouPresenter < Reports::Tickets::Delayed::BasePresenter

  COLUMNS = [
    :protocol,
    :organ,
    :created_at,
    :sou_type,
    :departments,
    :delayed_days
  ]
end
