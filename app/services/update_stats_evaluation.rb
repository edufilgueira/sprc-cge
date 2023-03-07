class UpdateStatsEvaluation

  def self.call(year, month, type)
    new(year, month, type).call
  end

  def initialize(year, month, type)
    @year = year.to_i
    @month = month.to_i
    @type = type
  end

  def call
    build_data
  end


  # privates

  private

  def build_data
    stats_evaluation.update(data: data)
  end

  def data
    return data_transparency if @type == 'transparency'

    {
      summary: summary_data,
      organs: organs_data,
      themes: themes_data
    }
  end

  def data_transparency
    {
      summary: summary_transparency
    }
  end

  def summary_transparency
    {
      total: total_survey_answers,
      average: average_survey_answers,
      very_dissatisfied: total_very_dissatisfied_count,
      somewhat_dissatisfied: total_somewhat_dissatisfied_count,
      neutral: total_neutral_count,
      somewhat_satisfied: total_somewhat_satisfied_count,
      very_satisfied: total_very_satisfied_count
    }
  end

  def summary_data
    {
      # indice de satisfação
      total_answered_tickets: summary_total_answered_tickets,
      total_user_evaluations: summary_total_user_evaluations,
      average_question_01_a: summary_average_question(:question_01_a),
      average_question_01_b: summary_average_question(:question_01_b),
      average_question_01_c: summary_average_question(:question_01_c),
      average_question_01_d: summary_average_question(:question_01_d),

      # qualidade do serviço de ouvidoria
      average_question_02: summary_average_question(:question_02),
      average_question_03: summary_average_question(:question_03)
    }
  end

  def organs_data
    #
    # orgãos mais bem avaliados
    #
    organs.map do |organ|
      { organ.acronym => organ_data(organ) }
    end.reduce(:merge)
  end

  def themes_data
    #
    # média de avaliação por tema
    #
    themes.map do |theme|
      { theme.name => theme_data(theme) }
    end.reduce(:merge)
  end

  def organ_data(organ)
    {
      organ_name: organ.name,
      total_tickets: total_tickets(organ),
      total_answered_tickets: total_answered_tickets(organ),
      total_user_evaluations: total_user_evaluations(organ),
      average_evaluations: average_evaluations(organ)
    }
  end

  def theme_data(theme)
    {
      average: average_by_theme(theme)
    }
  end

  #
  # summary
  #
  def summary_total_answered_tickets
    answer_ticket_scope.count
  end

  def summary_total_user_evaluations
    evaluations_default_scope.count
  end

  def summary_average_question(question)
    return nil if evaluations_default_scope.count < 1

    evaluations_default_scope.sum(question).to_f / evaluations_default_scope.count
  end
  #
  # summary
  #


  #
  # organ
  #
  def total_tickets(organ)
    ticket_scope.where(tickets: { organ_id: organ }).count
  end

  def total_answered_tickets(organ)
    answer_ticket_scope.where(tickets: { organ_id: organ}).count
  end

  def total_user_evaluations(organ)
    evaluations_tickets_scope.where(tickets: { organ_id: organ }).count
  end

  def average_evaluations(organ)
    evaluations = evaluations_tickets_scope.where(tickets: { organ_id: organ })

    return nil if evaluations.count < 1

    evaluations.sum(:average).to_f / evaluations.count
  end
  #
  # organ
  #

  #
  # themes
  #
  def average_by_theme(theme)
    evaluations = evaluation_budget_program_scope.where(budget_programs: { theme_id: theme })

    return nil if evaluations.count < 1

    evaluations.sum(:average) / evaluations.count
  end
  #
  # themes
  #


   #
  # Transparency
  #
  def total_survey_answers
    @total_survey_answers ||= survey_answers_scope.count
  end

  def average_survey_answers
    return nil if total_survey_answers < 1

    survey_answers_scope.sum(:evaluation_note).to_f / total_survey_answers
  end

  def total_very_dissatisfied_count
    survey_answers_scope.very_dissatisfied.count
  end

  def total_somewhat_dissatisfied_count
    survey_answers_scope.somewhat_dissatisfied.count
  end

  def total_neutral_count
    survey_answers_scope.neutral.count
  end

  def total_somewhat_satisfied_count
    survey_answers_scope.somewhat_satisfied.count
  end

  def total_very_satisfied_count
    survey_answers_scope.very_satisfied.count
  end

  #
  # Transparency
  #




  #
  # Scopes
  #
  def evaluations_tickets_scope
    @evaluations_tickets_scope ||= evaluations_default_scope.joins(answer: [:ticket])
  end

  def evaluations_default_scope
    #
    # Desconsiderando PS da rede ouvir
    #
    @evaluations_default_scope ||= Evaluation.where(created_at: default_date_range, evaluation_type: @type).joins(answer: [:ticket]).where(tickets: { rede_ouvir: false })
  end

  def evaluation_budget_program_scope
    @evaluation_budget_program_scope ||= evaluations_tickets_scope.joins(answer: [ticket: [classification: :budget_program]])
  end

  def answer_ticket_scope
    @answer_ticket_scope ||= ticket_scope.joins(:answers).where(answers: { status: Answer::VISIBLE_TO_USER_STATUSES, answer_type: :final }).distinct
  end

  def ticket_scope
    @type == 'call_center' ? attendance_ticket_scope : ticket_with_type_scope
  end

  def ticket_with_type_scope
    @ticket_with_type_scope ||= valid_tickets_scope.where(ticket_type: @type)
  end

  def attendance_ticket_scope
    @attendance_ticket_scope ||= Ticket.joins(parent: :attendance).where(confirmed_at: default_date_range, rede_ouvir: false)
  end

  def valid_tickets_scope
    @valid_tickets_scope ||= Ticket.left_joins(:tickets).where(tickets_tickets: { id: nil }, rede_ouvir: false).where(confirmed_at: default_date_range)
  end

  def survey_answers_scope
    @survey_answers_scope || Transparency::SurveyAnswer.where(date: default_date_range)
  end

  def organs
    @organs ||= ExecutiveOrgan.enabled
  end

  def themes
    @themes ||= Theme.enabled
  end

  def stats_evaluation
    @stats_evaluation = Stats::Evaluation.find_or_initialize_by(year: @year, month: @month, evaluation_type: @type)
  end

  def default_date_range
    beginning_of_month = Date.new(@year, @month).beginning_of_month.beginning_of_day
    end_of_month = Date.new(@year, @month).end_of_month.end_of_day

    beginning_of_month..end_of_month
  end
end
