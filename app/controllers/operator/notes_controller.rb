class Operator::NotesController < OperatorController
  include Operator::Notes::Breadcrumbs

  PERMITTED_PARAMS = [
    :note
  ]

  before_action :can_edit_note

  helper_method [:ticket]

  private

  def ticket
    resource
  end
  def resource_name
    'ticket'
  end

  def resource_show_path
    return operator_call_center_ticket_path(id: ticket) if comes_from_call_center?

    operator_ticket_path(ticket)
  end

  def can_edit_note
    authorize! :edit_note, ticket
  end

  def comes_from_call_center?
    request.referrer.to_s.include?('call_center_ticket')
  end
end
