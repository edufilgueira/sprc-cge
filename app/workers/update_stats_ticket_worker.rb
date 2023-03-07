class UpdateStatsTicketWorker
  include Sidekiq::Worker
  sidekiq_options queue: :low

  def perform(ticket_type, year = Date.today.year, month_start = 1, month_end = Date.today.month, organ_id = nil, subnet_id = nil)
    stats_ticket = Stats::Ticket.find_or_create_by(
      ticket_type: ticket_type, year: year, month_start: month_start,
      month_end: month_end, organ_id: organ_id, subnet_id: subnet_id)

    UpdateStatsTicket.call(stats_ticket.id)
  end
end
