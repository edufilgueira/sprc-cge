class Reports::Tickets::GrossExport::SummaryPresenter
  attr_reader :scope, :gross_export

  def initialize(scope, gross_export)
    @scope = scope
    @gross_export = gross_export
  end

  def name_report
    name = gross_export.title
    I18n.t('presenters.reports.tickets.gross_export.summary.infos.name_report', name: name)
  end

  def created_by
    name = gross_export.user.name
    I18n.t('presenters.reports.tickets.gross_export.summary.infos.created_by', name: name)
  end

  def created_at
    date = gross_export.created_at
    I18n.t('presenters.reports.tickets.gross_export.summary.infos.created_at', date: I18n.l(date, format: :long))
  end

  def creator_email
    email = gross_export.user.email
    I18n.t('presenters.reports.tickets.gross_export.summary.infos.creator_email', email: email)
  end

  def operator_type
    operator_type = gross_export.user.operator_type_str
    I18n.t('presenters.reports.tickets.gross_export.summary.infos.operator_type', operator_type: operator_type)
  end

  # Determina a quantidade de tickets confirmados no periodo do escopo / nao olha para linhas de reabertura mas sim para ticket ids.
  def tickets_count
    I18n.t('presenters.reports.tickets.gross_export.summary.infos.tickets_count', count: within_confirmed_at(scope).without_other_organs.count)
  end

  def tickets_invalidate_count
    I18n.t('presenters.reports.tickets.gross_export.summary.infos.tickets_invalidated_count', count: within_confirmed_at(scope).invalidated.count)
  end

  def tickets_other_organs_count
    other_organs_count =
      within_confirmed_at(scope).with_other_organs.count +
      reopened(scope.with_other_organs).count

    I18n.t('presenters.reports.tickets.gross_export.summary.infos.tickets_other_organs_count', count: other_organs_count)
  end

  def tickets_reopened_count
    reopened_count = reopened(scope.without_other_organs).count

    I18n.t("presenters.reports.tickets.gross_export.summary.infos.reopened_at.#{ gross_export.ticket_type_filter }", count: reopened_count)
  end

  private

  def reopened(reopened_scope)
    reopened_scope.joins(:ticket_logs).where(ticket_logs: {
      action: [:reopen, :pseudo_reopen],
      created_at: date_range
    })
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

  def within_confirmed_at(tickets)
    tickets.where(confirmed_at: date_range)
  end

  def date_filter
    gross_export.filters[:confirmed_at]
  end
end
