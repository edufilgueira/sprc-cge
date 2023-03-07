module ReportsHelper

  def report_filter_value(filter_key, filter_value)
    case filter_key
    when 'ticket_type', 'deadline', 'departments_deadline', 'internal_status', 'sou_type', 'used_input', 'parent_protocol', 'answer_type'
      Ticket.human_attribute_name("#{filter_key}.#{filter_value}")
    when 'expired', 'priority', 'finalized', 'denunciation', 'other_organs', 'rede_ouvir_scope'
      casted_value = ActiveModel::Type::Boolean.new.cast(filter_value)
      I18n.t("boolean.#{casted_value}")
    when 'organ', 'budget_program', 'topic', 'subtopic', 'state', 'city', 'subnet', 'department', 'sub_department', 'service_type'
      klass = filter_key.camelize.constantize
      klass.find(filter_value).title
    when 'confirmed_at'
      start_value = confirmed_at_start_value(filter_value)
      end_value = confirmed_at_end_value(filter_value)
      I18n.t("report.filters.range", start: start_value, end: end_value)
    when 'search'
      filter_value
    when 'data_scope'
      I18n.t("report.filters.data_scope.#{filter_value}")
    when 'sheets'
      sheets = []

      if filter_value.first.include? '::Sic::'
        filter_value.each do |sic_sheet|
          sheets << TicketReport.sic_sheet_name(sic_sheet)
        end
      else
        filter_value.each do |sou_sheet|
          sheets << TicketReport.sou_sheet_name(sou_sheet)
        end
      end

      sheets.join(', ')
    end
  end

  private

  def confirmed_at_start_value(filter_value)
    filter_value[:start] || default_confirmed_at_start_value
  end

  def confirmed_at_end_value(filter_value)
    filter_value[:end] || default_confirmed_at_end_value
  end

  def default_confirmed_at_start_value
    I18n.l(Date.new(0))
  end

  def default_confirmed_at_end_value
    I18n.l(Date.today)
  end
end
