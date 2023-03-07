class Abilities::Users::Operator::SubnetSectoral < Abilities::Users::Operator::SouSectoral

  private

  def can_manage_evaluation_exports(_)
    can :create, EvaluationExport
  end

  def can_manage_stats_tickets(user)
    can :index, Stats::Ticket

    can :create, Stats::Ticket do |stats|
      stats_not_started?(stats) &&
      (stats.subnet.blank? || stats_subnet_eql?(stats, user))
    end
  end

  def can_manage_ticket_departments(user)
    can [:edit, :update, :poke], TicketDepartment do |ticket_department|
      ticket = ticket_department.ticket
      ticket.active? &&
      resource_organ_eql?(ticket, user) &&
      resource_subnet_eql?(ticket, user)
    end
  end

  def can_manage_departments(user)
    can :create, Department

    can [:read, :update, :destroy], Department do |department|
      department.subnet == user.subnet
    end
  end

  def can_email_reply(_)
  end

  # Helpers

  def user_can_manage_ticket?(ticket, user)
    resource_organ_eql?(ticket, user) && resource_subnet_eql?(ticket, user)
  end

  def stats_subnet_eql?(stats, user)
    stats.subnet_id == user.subnet_id
  end


  ## Users

  def can_create_or_view_users(current_user)
    can [:create, :index, :show], User do |user|
      user_subnet =
        case user.operator_type
        when 'internal'
          user.department.subnet
        when 'subnet_sectoral'
          user.subnet
        end

      current_user.subnet == user_subnet
    end
  end

  def can_update_users(current_user)
    can [:read, :update, :toggle_disabled], User do |user|
      current_user.subnet == user.subnet && user.internal?
    end
  end


  ## Answers

  def can_approve_and_reject_answer(_)
    can [:approve_answer, :reject_answer], Answer do |answer|
      answer.awaiting? && answer.subnet_department?
    end
  end
end
