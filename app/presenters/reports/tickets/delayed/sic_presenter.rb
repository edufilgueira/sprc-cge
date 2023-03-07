class Reports::Tickets::Delayed::SicPresenter < Reports::Tickets::Delayed::BasePresenter

  COLUMNS = [
    :protocol,
    :organ,
    :created_at,
    :departments,
    :delayed_days
  ]
end
