#
# Ability para usuários não logados da plataforma.
#

class Abilities::Users::Public < Abilities::Users::Base

  def initialize
    can_change_extension_status
    can_view_answer
    can_view_public_ticket
    can_view_user_info
    can_revision_problem_situation
    can_prioritize_regional_strategy
  end


  private

  def can_view_user_info
    can :view_user_info, Ticket do |ticket|
      !ticket.hide_personal_info?
    end
  end

  def can_change_extension_status
    can [:change_extension_status], Extension do |extension|
      extension.in_progress?
    end
  end

  def can_view_public_ticket
    can [:view_public_ticket], Ticket do |ticket|
      ticket.public_ticket? and !ticket.denunciation?
    end
  end

end
