module TicketLogHelper

  def invalidate_status_class(status)
    case status
    when 'approved'
      'alert-success'
    when 'rejected'
      'alert-danger'
    when 'waiting'
      'alert-info'
    end
  end

  def ticket_log_date_author(ticket_log)
    date = I18n.l(ticket_log.created_at, format: :shorter)

    return date unless ticket_log.data[:responsible_as_author].present?

    I18n.t("shared.ticket_logs.confirm.author", date: date, author: ticket_log.data[:responsible_as_author])
  end

  def ticket_log_denunciation_type_title(ticket_log)
    denunciation_type =
      if ticket_log.data[:denunciation_type].present?
        t("ticket.denunciation_types.#{ticket_log.data[:denunciation_type]}")
      else
        t('shared.ticket_logs.change_denunciation_type.undefined')
      end

    I18n.t("shared.ticket_logs.change_denunciation_type.title", to: denunciation_type)
  end

  def responsible_or_user(ticket_log)
   responsible_or_user = ticket_log.responsible.present? ? ticket_log.responsible : User.unscoped.find(ticket_log.responsible_id)
  end

  def view_evaluation_question(ticket)
    # Libera formulario de pesquisa se other_organs ou DPGE não foi selecionado
    !(ticket.other_organs or ticket.organ_id == ExecutiveOrgan.dpge.id)
  end
end
