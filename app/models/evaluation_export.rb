class EvaluationExport < ApplicationRecord
  include EvaluationExport::Search
  include ::Reportable
  include Operator::Reports::EvaluationExports::Filters

  def sorted_tickets
    Ticket.left_joins(:tickets).where(tickets_tickets: { id: nil })
      .joins(answers: :evaluation)
  end
end
