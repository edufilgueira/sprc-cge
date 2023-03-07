class Abilities::Users::Operator::SubnetChief < Abilities::Users::Operator::Chief

  private

  def can_manage_evaluation_exports
    can :create, EvaluationExport
  end


  # Helpers

  def user_can_manage_ticket?(ticket, user)
    resource_organ_eql?(ticket, user) && resource_subnet_eql?(ticket, user)
  end
end
