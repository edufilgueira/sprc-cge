class Reports::Tickets::Evaluations::BasePresenter

  attr_reader :scope

  COLUMNS = [
    :protocol,
    :organ,
    :sou_type,
    :used_input,
    :created_at,
    :question_01_a,
    :question_01_b,
    :question_01_c,
    :question_01_d,
    :question_02,
    :question_03,
    :question_04,
    :average,
  ]

  def initialize(scope)
    @scope = Evaluation.joins(answer: :ticket).where(tickets: { id: scope.ids })
  end

  def rows
    scope.map { |evaluation| row(evaluation) }
  end

  private

  def row(evaluation)
    [
      evaluation.ticket.parent_protocol,
      evaluation.ticket.organ_acronym,
      evaluation.ticket.sou_type_str,
      evaluation.ticket.used_input_str,
      I18n.l(evaluation.created_at, format: :date),
      evaluation.question_01_a,
      evaluation.question_01_b,
      evaluation.question_01_c,
      evaluation.question_01_d,
      evaluation.question_02,
      evaluation.question_03,
      evaluation.question_04,
      evaluation.average
    ]
  end
end
