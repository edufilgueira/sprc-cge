class Reports::Tickets::Evaluations::SouPresenter < Reports::Tickets::Evaluations::BasePresenter

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
    :question_05,
    :average,
  ]

  private

  def row(evaluation)

    question_05_content =
      if evaluation.question_05.present?
        I18n.t("shared.answers.evaluations.questions.sou.question_05.#{evaluation.question_05}")
      else
        ''
      end

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
      question_05_content,
      evaluation.average
    ]
  end

end
