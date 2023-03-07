module EvaluationExportsHelper

  def can_select_ticket_type?(user)
    return false unless user.operator?

    case user.operator_type.to_sym
    when :cge, :call_center_supervisor, :chief, :subnet_sectoral, :subnet_sectoral, :subnet_chief, :coordination
      true
    when :sou_sectoral
      user.acts_as_sic?
    else
      false
    end
  end
end
