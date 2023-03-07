class Abilities::Users::Base < Abilities::Base

  private

  def can_manage_participant_profile
    can [:revision], PPA::Plan do |plan|
      plan.revising?
    end
  end

  def can_edit_itself(user)
    can [:edit, :update], User do |user_to_edit|
      (user == user_to_edit)
    end
  end

  def can_view_denunciation(user)
    can [:view_denunciation, :edit_denunciation_organ], Ticket do |ticket|
      ticket.denunciation? &&
        (ticket.created_by_id == user.id ||
        user.operator_denunciation? || user.call_center_operator?)
    end
  end

  def can_letter_answer_option(user)
    can :answer_by_letter, User do |user|
      user.operator_type != 'call_center' and !user.user?
    end
  end

  def can_phone_answer_option(user)
    can :answer_by_phone, User do |user|
      !user.user?
    end
  end

  def can_prioritize_regional_strategy
    can :prioritize_regional_strategy, PPA::Plan do |plan|
      plan.in_time_to_prioritization_regional_strategies?
    end
  end

  def can_revision_problem_situation
    can :revision_problem_situation, PPA::Plan do |plan|
      plan.in_time_to_revision_problem_situation?
    end
  end

  # PPA

  # Tela de Revisão
  def can_review_problem_situation(user)
    can [:create], PPA::Revision::Review::ProblemSituationStrategy
    can [:read, :edit, :update, :conclusion, :themes_list], PPA::Revision::Review::ProblemSituationStrategy, user_id:  user.id
    can [:show, :destroy, :edit, :update], PPA::Revision::Review::RegionTheme, problem_situation_strategy: {user_id:  user.id }
  end

  # Tela de Priorização
  def can_review_prioritization(user)
    can [:create], PPA::Revision::Prioritization
    can [:read, :edit, :update, :conclusion, :themes_list, :destroy, :show], PPA::Revision::Prioritization, user_id:  user.id
    can [:show, :destroy, :edit, :update], PPA::Revision::Prioritization::RegionTheme, prioritization: {user_id:  user.id }
  end

  # Tela de Revisão
  def can_review_evaluation
    can :can_review_evaluation, PPA::Plan do |plan|
      plan.in_time_to_evaluation?
    end
  end
end