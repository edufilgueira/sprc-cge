module NotesHelper

  def notes_link_to(namespace, ticket)
    from_param = controller&.request&.referrer&.include?('call_center_tickets') ? '&from=call_center_ticket' : ''
    send("edit_#{namespace}_note_path", ticket) + from_param
  end
end
