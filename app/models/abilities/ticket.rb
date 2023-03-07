#
# Ability para usuários do tipo 'protocolo/senha'.
#

class Abilities::Ticket < Abilities::Base

  def initialize(resource)
    # Só pode visualizar, editar e atualizar o próprio ticket que estiver logado

    can [:show, :history], Ticket do |ticket|
      ticket == resource
    end

    can_view_answer

    can_appeal_ticket(resource)
    can_reopen_ticket(resource)
    can_create_public_comment

    can_evaluate(resource)

    can :view_user_info, Ticket

    can_view_deadline

    can_view_ticket_user_print_password(resource)

    can_reopen_ticket_with_immediate_answer(resource)


    # Comments
    can_view_comment(resource)

    # Attachments
    can_view_attachment(resource)
    can_destroy_attachment(resource)

  end

  private

  def user_ticket_owner?(current_ticket, resource)
    ticket_belongs_to_resource(resource, current_ticket)
  end

  def ticket_belongs_to_resource(resource, current_ticket)
    return resource.id == current_ticket.id if resource.parent?

    resource.parent_id == current_ticket.id
  end

  def can_reopen_ticket_with_immediate_answer(resource)
    can :reopen_ticket_with_immediate_answer, Ticket do |ticket|
      !ticket.immediate_answer?
    end
  end
end
