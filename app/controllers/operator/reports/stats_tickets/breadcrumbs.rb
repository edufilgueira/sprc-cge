module Operator::Reports::StatsTickets::Breadcrumbs
  include ::Reports::BaseBreadcrumbs

  private

  def report_type
    :stats_tickets
  end

  def report_title
    t('operator.reports.stats_tickets.show.title')
  end
end
