class SolvabilityReport < ApplicationRecord
  include ::Reportable
  include Operator::Reports::TicketReports::Filters

  def sorted_tickets
    self.user.operator_accessible_tickets_for_report
  end
end
