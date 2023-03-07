class Reports::Tickets::GrossExport::BasePresenter

  attr_reader :scope, :gross_export

  COLUMNS = []

  COLUMNS_CREATOR_INFO = [
    :person_type,
    :user_name,
    :user_social_name,
    :user_email,
    :user_phone,
    :user_cell_phone,
    :gender
  ]

  COLUMNS_DESCRIPTION = [:description]

  COLUMNS_ANSWERS_DESCRIPTION = [
    :answers_description,
    :answers_department_created_at
  ]

  COLUMNS_ORGAN = [:organ]

  def initialize(scope, gross_export_id)
    @scope = scope
    @gross_export = GrossExport.find(gross_export_id)
  end

  def rows
    results = []

    scope.each do |ticket|
      result = row(ticket)

      if ticket.confirmed_at.between?(beginning_date, end_date) && !ticket.pseudo_reopen?
        results << result
      end

      results += build_reopened_rows(ticket, result) if ticket.reopened?
    end

    results
  end

  def active_columns
    columns = self.class::COLUMNS

    columns = remove_columns(columns, self.class::COLUMNS_ORGAN) unless user.permission_to_show_organs_on_reports?
    columns = remove_columns(columns, self.class::COLUMNS_CREATOR_INFO) unless gross_export.load_creator_info?
    columns = remove_columns(columns, self.class::COLUMNS_DESCRIPTION) unless gross_export.load_description?
    columns = remove_columns(columns, self.class::COLUMNS_ANSWERS_DESCRIPTION) unless gross_export.load_answers?

    columns
  end

  private

  def row(ticket)
    active_columns.map { |column| send(column, ticket) }
  end

  def remove_columns(columns, columns_remove)
    columns - columns_remove
  end

  def year(ticket)
    ticket.confirmed_at.year if ticket.confirmed_at.present?
  end

  def sou_type(ticket)
    ticket.sou_type_str
  end

  def denunciation_assurance(ticket)
    ticket.denunciation_assurance_str
  end

  def organ(ticket)
    ticket.organ_acronym || '-'
  end

  def subnet(ticket)
    ticket.subnet_acronym || '-'
  end

  def topic(ticket)
    ticket&.classification&.topic_name || '-'
  end

  def subtopic(ticket)
    ticket&.classification&.subtopic_name || '-'
  end

  def budget_program(ticket)
    ticket&.classification&.budget_program_name || '-'
  end

  def service_type(ticket)
    ticket&.classification&.service_type_name || '-'
  end

  def departments(ticket)
    ticket_departments = ticket.ticket_departments

    return '-' if ticket_departments.empty?

    ticket_departments.map(&:department_acronym).join("; ")
  end

  def departments_classification(ticket)
    ticket&.classification&.department_name
  end

  def subdepartment(ticket)
    ticket&.classification&.sub_department_name
  end

  def protocol(ticket)
    ticket.parent_protocol
  end

  def created_by(ticket)
    ticket_target = ticket_parent(ticket)
    ticket_target.created_by.blank? ? '-' : ticket_target.created_by.as_author
  end

  def shared(ticket)
    I18n.t("boolean.#{ticket.shared?}").upcase
  end

  def status(ticket)
    ticket.status_str
  end

  def internal_status(ticket)
    ticket.internal_status_str
  end

  def origem_input(ticket)
    ticket.used_input_str
  end

  def month(ticket)
    ticket.confirmed_at.month if ticket.confirmed_at.present?
  end

  def confirmed_at(ticket)
    I18n.l(ticket.confirmed_at, format: :date) if ticket.confirmed_at.present?
  end

  def has_filter_ticket_type_sou?
    gross_export.filters[:ticket_type] == 'sou'
  end

  def approved_answers(ticket)
    ticket.answers.approved_for_citizen
  end

  def approved_answer(ticket)
    return approved_answers(ticket).last unless has_filter_ticket_type_sou?
    ticket.first_version_answer
  end

  def final_answers(ticket)
    ticket.answers.where(answers: {
      answer_type: :final,
      answer_scope: Answer::SCOPES_ALLOWING_FINAL_ANSWER,
      status: Answer::APPROVED_STATUSES_TO_FINALIZE_TICKET
    })
  end

  def final_answer(ticket)
    final_answers(ticket).try(:last)
  end

  def answered_at(ticket)
    I18n.l(approved_answer(ticket).created_at, format: :date) if approved_answer(ticket).present?

  end

  def final_answer_at(ticket)
    I18n.l(final_answer(ticket).created_at, format: :date) if final_answer(ticket).present?
  end

  def answer_time_in_days(ticket)
    if ticket.pseudo_reopen?
      ticket.reopen_pseudo_time_in_days
    elsif ticket.confirmed_at
      ticket.first_version_time_in_days_count
    end
  end

  def immediate_answer(ticket)
    I18n.t("boolean.#{ticket.immediate_answer?}").upcase
  end

  def reopened(ticket)
    0
  end

  def ticket_logs_with_reopen(ticket)
    ticket.ticket_logs.reopen
  end

  def reopened_description(ticket)
    ''
  end

  def appeals(ticket)
    ticket_parent_appeals(ticket) || ticket.appeals
  end

  def ticket_parent_appeals(ticket)
    ticket_parent(ticket).appeals if is_first_children_ticket?(ticket)
  end

  def is_first_children_ticket?(ticket)
    ticket_parent(ticket).tickets.order(id: :asc).first.try(:id) == ticket.id if ticket_parent(ticket).present?
  end

  def neighborhood(ticket)
    ticket.answer_address_neighborhood
  end

  def city(ticket)
    ticket.city_name
  end

  def state(ticket)
    ticket.city_state_acronym
  end

  def answer_type(ticket)
    ticket.answer_type_str if ticket.answer_type.present?
  end

  def description(ticket)
    description_str = ticket.denunciation? ? ticket.denunciation_description : ticket.description
    ActionController::Base.helpers.sanitize(description_str, tags: [])
  end

  def answers_description(ticket)
    return unless ticket.final_answer? || ticket.partial_answer?

    answers = ""
    ticket.answers.approved_for_citizen.each do |a|
      answer_description = I18n.t("presenters.reports.tickets.gross_export.answers.description" , date: a.created_at, user: a.as_author, description: a.description)
      cge_approved_by = answer_approved_by_info(ticket, a)

      answers += "#{answer_description}\n#{cge_approved_by}\n\n"
    end

    ActionController::Base.helpers.sanitize(answers, tags: [])
  end

  def answers_department_created_at(ticket)
    positionings = ""

    positionings_approveds(ticket).each do |ticket_log|
      date_str = I18n.l(ticket_log.created_at, format: :date)
      name = ticket_log_responsible_name(ticket_log)
      positionings += "#{date_str} - #{name}\n"
    end

    return '-' if positionings.blank?

    positionings
  end

  def positionings_approveds(ticket)
    ticket.ticket_logs.answer.joins(:answer)
      .where(answers: {answer_scope: [:department, :subnet_department], status: :sectoral_approved})
  end

  def ticket_log_responsible_name(ticket_log)
    ticket_log.responsible.respond_to?('as_author') ?
      ticket_log.responsible.as_author :
      "[#{ticket_log.responsible.ticket_department.title}] #{ticket_log.responsible.email}"
  end

  def answer_approved_by_info(ticket, answer)
    ticket_target = ticket_parent(ticket)
    ticket_log_cge = ticket_target.ticket_logs.where(resource_id: answer.id, action: TicketLog.actions[:answer_cge_approved]).first
    ticket_log_cge.blank? ? "" : I18n.t("presenters.reports.tickets.gross_export.answers.approved_by", date: I18n.l(ticket_log_cge.created_at, format: :date), user: ticket_log_cge.data[:responsible_as_author])
  end

  def deadline(ticket)
    return '-' if ticket.responded_at.present?
    ticket.deadline
  end

  def evaluation(ticket)
    ticket.last_evaluation_average
  end

  def has_extension(ticket)
    I18n.t("boolean.#{ticket.extended}").upcase
  end

  def answer_classification(ticket)
    ticket.answer_classification_str if ticket.answer_classification.present?
  end

  def attendance_evaluation(ticket)
    attendance_evaluation = ticket.attendance_evaluation

    return unless attendance_evaluation.present?
    build_attendance_evaluation(attendance_evaluation)
  end

  def average_attendance_evaluation_organ(ticket)
    ticket.organ_average_attendance_evaluation
  end

  def user_name(ticket)
    ticket.name
  end

  def user_social_name(ticket)
    ticket.social_name
  end

  def user_phone(ticket)
    ticket.answer_phone
  end

  def user_cell_phone(ticket)
    ticket.answer_cell_phone
  end

  def user_email(ticket)
    ticket.email
  end

  def other_organs(ticket)
    I18n.t("boolean.#{ticket.other_organs || false}").upcase
  end

  def person_type(ticket)
    ticket.person_type_str
  end

  def gender(ticket)
    ticket.gender_str if ticket.gender.present?
  end

  def denunciation_organ(ticket)
    return '-' unless ticket.denunciation?

    ticket.denunciation_organ&.full_title
  end

  def last_answer_status(ticket)
    return if ticket.invalidated?

    if !has_filter_ticket_type_sou? && ticket.answers.approved_for_citizen.by_version(0).count>0
      answer = ticket.answers.approved_for_citizen.by_version(0).first
    else
      debugger
      answer = ticket.answers.approved_for_citizen.by_version(ticket.reopened).first
    end

    answered = answer.present?
    deadline = answer&.sectoral_deadline || ticket.deadline
    status = answer_status_str(answered, deadline)

    I18n.t("presenters.reports.tickets.gross_export.last_answer_status.#{status}")
  end

  def last_answer_status_department(ticket)
    ticket_departments = ticket.ticket_departments

    return '-' if ticket_departments.empty?

    result_departments = ''
    ticket_departments.each do |ticket_department|
      answered = ticket_department.answered?
      deadline = ticket_department.deadline || 0

      status = answer_status_str(answered, deadline)

      status_str = I18n.t("presenters.reports.tickets.gross_export.last_answer_status.#{status}")
      result_departments += "#{ticket_department.department_acronym} - #{status_str}\n"
    end

    result_departments
  end

  def answer_status_str(answered, deadline)
    if answered_on_time?(answered, deadline)
      return :answered_on_time
    elsif answered_out_time?(answered, deadline)
      return :answered_out_time
    elsif answer_in_progress?(answered, deadline)
      return :in_progress
    elsif answer_delayed?(answered, deadline)
      return :delayed
    end
  end

  def answered_on_time?(answered, deadline)
    return answered && deadline >= 0 if !deadline.nil?

    false
  end

  def answered_out_time?(answered, deadline)
    return answered && deadline < 0 if !deadline.nil?

    false
  end

  def answer_in_progress?(answered, deadline)
    return !answered && deadline >= 0 if !deadline.nil?

    false
  end

  def answer_delayed?(answered, deadline)
    return !answered && deadline < 0 if !deadline.nil?

    false
  end

  def cell_line_break
    "\x0D\x0A"
  end

  def cell_separator
    "#{cell_line_break}---------------------------#{cell_line_break}"
  end

  def build_attendance_evaluation(attendance_evaluation)
    "#{AttendanceEvaluation.human_attribute_name(:clarity)}: #{attendance_evaluation.clarity}#{cell_line_break}" +
    "#{AttendanceEvaluation.human_attribute_name(:content)}: #{attendance_evaluation.content}#{cell_line_break}" +
    "#{AttendanceEvaluation.human_attribute_name(:wording)}: #{attendance_evaluation.wording}#{cell_line_break}" +
    "#{AttendanceEvaluation.human_attribute_name(:kindness)}: #{attendance_evaluation.kindness}#{cell_line_break}#{cell_line_break}" +
    "#{AttendanceEvaluation.human_attribute_name(:average)}: #{attendance_evaluation.average}#{cell_separator}" +
    "#{AttendanceEvaluation.human_attribute_name(:comment)}:#{cell_line_break}#{attendance_evaluation.comment}"
  end

  def ticket_parent(ticket)
    ticket.parent || ticket
  end

  def user
    gross_export.user
  end

  def anonymous(ticket)
    I18n.t("boolean.#{ticket.anonymous?}").upcase
  end

  def build_reopened_rows(ticket, default_row)
    filtered_ticket_logs(ticket).map do |reopen|
      reopend_row = default_row.dup

      index_reopened_description = active_columns.index(:reopened_description)
      reopend_row[index_reopened_description] = reopened_description_by_ticket_log(reopen)

      index_year = active_columns.index(:year)
      reopend_row[index_year] = reopen.created_at.year

      index_month = active_columns.index(:month)
      reopend_row[index_month] = reopen.created_at.month

      index_status = active_columns.index(:internal_status)
      reopend_row[index_status] =  reopen.reopend_and_pseudo_reopend_ticket_internal_status

      index_status = active_columns.index(:immediate_answer)
      reopend_row[index_status] = I18n.t("boolean.false").upcase

      index_confirmed_at = active_columns.index(:confirmed_at)
      reopend_row[index_confirmed_at] = I18n.l(reopen.created_at, format: :date)

      answer = ticket.answers.approved_for_citizen.by_version(reopen.data[:count]).first

      index_answered_at = active_columns.index(:answered_at)
      reopend_row[index_answered_at] = answer.present? ? I18n.l(answer.created_at, format: :date) : '-'

      final_answer = final_answers(ticket).by_version(reopen.data[:count]).first
      index_final_answer_at = active_columns.index(:final_answer_at)
      reopend_row[index_final_answer_at] = final_answer.present? ? I18n.l(final_answer.created_at, format: :date) : '-'

      index_answer_days = active_columns.index(:answer_time_in_days)
      reopend_row[index_answer_days] = answer.present? ? (answer.created_at.to_date - reopen.created_at.to_date).to_i : '-'

      answered = answer.present?
      deadline = answer&.sectoral_deadline || ticket.deadline
      status = answer_status_str(answered, deadline)

      index_last_answer_status = active_columns.index(:last_answer_status)
      reopend_row[index_last_answer_status] = ticket.invalidated? ? nil : I18n.t("presenters.reports.tickets.gross_export.last_answer_status.#{status}")

      index_reopened = active_columns.index(:reopened)
      reopend_row[index_reopened] = reopen.data[:count]

      index_deadline = active_columns.index(:deadline)
      reopend_row[index_deadline] = answered ? '-' : ticket.deadline

      reopend_row
    end
  end

  def reopened_description_by_ticket_log(ticket_log_reopen)
    ActionController::Base.helpers.sanitize(
      ticket_log_reopen.description || "", tags: []
    )
  end

  def beginning_date
    return Date.new(0) unless date_filter.present?
    date_filter[:start].to_date
  end

  def end_date
    return Date.today.end_of_day unless date_filter.present?
    date_filter[:end].to_date.end_of_day
  end

  def date_range
    beginning_date..end_date
  end

  def filtered_ticket_logs(ticket)
    ticket.ticket_logs.where(action: [:pseudo_reopen, :reopen], created_at: date_range).sorted
  end

  def reopen_pseudo_time_in_days
    ticket_logs_reopened_versions = ticket_logs.reopen.pluck(:data).pluck(:count).uniq

    answers.approved_for_citizen.each do |answer|
     if ticket_logs_reopened_versions.exclude? answer.version
       return (answer.created_at.to_date - confirmed_at.to_date).to_i
     end
    end

    '-'
  end

  def date_filter
    gross_export.filters[:confirmed_at]
  end
end
