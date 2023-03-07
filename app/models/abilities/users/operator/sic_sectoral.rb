class Abilities::Users::Operator::SicSectoral < Abilities::Users::Operator::SouSectoral

  def initialize(user)
    super
    can_show_protester_info
  end

  private

  def can_manage_evaluation_exports(user)
    can :create, EvaluationExport do |evaluation_export|
      evaluation_export.ticket_type_filter == 'sic'
    end
  end

  def user_can_manage_ticket?(ticket, user)
    ticket.sic? && resource_organ_eql?(ticket, user)
  end

  def can_change_sou_type(_user)
  end

  def can_change_answer_certificate(_)
    can :change_answer_certificate, Answer do |answer|
      answer.ticket_sic? 
    end
  end
 end