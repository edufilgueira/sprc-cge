module ExtensionsHelper

  def extension_class(status)
    case status
    when 'approved'
      'alert-success'
    when 'rejected'
      'alert-danger'
    when 'in_progress'
      'alert-info'
    when 'cancelled'
      'alert-warning'
    end
  end

  def extension_request_for_select
    %w( approved rejected ).map do |status|
      [Extension.human_attribute_name("status.#{status}"), status]
    end
  end

  def extension_operator_path(ticket)
    new_operator_ticket_extensions_organ_path(ticket)
  end

  def extension_operator_cancel_path(ticket)
    extension = ticket.extension_organ_in_progress(ticket.next_extension_number)
    operator_ticket_extensions_organ_path(ticket, extension)
  end
end
