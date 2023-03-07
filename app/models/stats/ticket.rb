#
# Representa dos dados estatísticos de manifestações e solicitações
#
class Stats::Ticket < ApplicationRecord

  enum ticket_type: [:sic, :sou]

  enum status: [:ready, :started, :created, :error]

  # Associations

  belongs_to :organ
  belongs_to :subnet

  # Validations

  ## Presence

  validates :ticket_type,
    :month_start,
    :month_end,
    :year,
    presence: true

  ## Uniqueness
  validates_uniqueness_of :ticket_type,
    scope: [:month_start, :month_end, :year, :organ_id, :subnet_id]


  # Serializations

  serialize :data, Hash

  def self.current(ticket_type)
    find_by(ticket_type: ticket_type, month_start: 1, month_end: Date.current.month, year: Date.current.year, organ_id: nil, subnet_id: nil)
  end

  def self.current_by_scope!(scope)
    stats = find_or_create_by(ticket_type: scope[:ticket_type], month_start: scope[:month_start], month_end: scope[:month_end], year: scope[:year], organ_id: scope[:organ_id], subnet_id: scope[:subnet_id])
    call_stats_worker(stats) if stats.status.nil?

    stats
  end

  # Helpers

  def formated_date
    "#{I18n.t('date.month_names')[month_start]} - #{I18n.l(Date.new(self.year, self.month_end), format: :month_year_long)}"
  end

  private

  def self.call_stats_worker(stats)
    UpdateStatsTicketWorker.perform_async(stats.ticket_type, stats.year, stats.month_start, stats.month_end, stats.organ_id, stats.subnet_id)
  end
end
