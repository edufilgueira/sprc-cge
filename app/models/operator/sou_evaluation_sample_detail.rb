class Operator::SouEvaluationSampleDetail < ApplicationRecord
  
  before_destroy :set_remove_attendance_evaluation, :set_release_ticket_for_evaluation

  # Setup

  acts_as_paranoid

  belongs_to :sou_evaluation_sample
  belongs_to :ticket

  # Delegates
  delegate :name, to: :ticket, prefix: true, allow_nil: true
  delegate :sou_type, to: :ticket, prefix: true, allow_nil: true
  delegate :parent_protocol, to: :ticket, prefix: true, allow_nil: true
  delegate :description, to: :ticket, prefix: true, allow_nil: true

  def self.with_rated
  	where(rated: true)
  end

  private

  # Deleta a avaliação interna caso exista
  def set_remove_attendance_evaluation
    ticket.attendance_evaluation.try(:destroy)
  end

  # Desmarca o ticket liberando para novas amostras de avaliação interna
  def set_release_ticket_for_evaluation
    Ticket.where(id: [self.ticket.id, self.ticket.parent.id])
      .update(marked_internal_evaluation: false)
  end

end
