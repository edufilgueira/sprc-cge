#
# Ability para usuários logados da plataforma.
#

class Abilities::Users::User < Abilities::Users::Base

  #
  # Essa classe não deve ser instanciada diretamente. Apenas através do
  # Abilities::User.factory que irá verificar qual o tipo do usuário para
  # definir suas abilities.
  #
  def initialize(user)
    setup_user_abilities(user)
  end

  private

  def setup_user_abilities(user)
    can_edit_itself(user)

    can [:create, :search], Ticket

    #can :view_user_info, Ticket
    can_view_user_info

    can_manage_own_tickets(user)

    can_view_answer

    can_appeal_ticket(user)
    can_reopen_ticket(user)

    can_view_denunciation(user)
    can_create_public_comment

    can_publish_ticket(user)
    can_evaluate(user)

    can_view_deadline

    can_view_ticket_user_print_password(user)

    can_change_ticket_type(user)

    can_reopen_ticket_with_immediate_answer(user)

    # Comments
    can_view_comment(user)


    # Attachments
    can_view_attachment(user)
    can_destroy_attachment(user)

    #PPA
    can_manage_participant_profile
    can_prioritize_regional_strategy
    can_revision_problem_situation
    can_review_problem_situation(user)
    can_review_prioritization(user)
    can_review_evaluation
  end

  def can_manage_own_tickets(user)
    can [:read, :history], Ticket do |ticket|
      ticket_owner(user, ticket)
    end
  end

  def can_publish_ticket(user)
    can :publish_ticket, Ticket do |ticket|
      ticket_owner(user, ticket) && ticket.eligible_to_publish?
    end
  end

  def ticket_belongs_to_resource(ticket, user)
    ticket.created_by.blank? || ticket.created_by == user
  end

  def ticket_owner(user, ticket)
    ticket.created_by_id == user.id
  end

  def user_ticket_owner?(current_user, ticket)
    ticket_parent = ticket.parent || ticket

    ticket_owner(current_user, ticket_parent)
  end

  def can_view_user_info
    can :view_user_info, Ticket do |ticket|
      !ticket.hide_personal_info?
    end
  end

  def can_change_ticket_type(user)
    can :change_type, Ticket do |ticket|
      ticket_owner(user, ticket) &&

      # é obrigatório SIC possuir documento
      ! ticket.document.blank? &&

      # não deve existir ticket da rede ouvir do tipo SIC
      ! ticket.rede_ouvir?
    end
  end
end