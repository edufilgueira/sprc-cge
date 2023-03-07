module ToolbarHelper

  def user_association(user)
    return "[#{user.department_acronym}]" if user.department.present?
    "[#{user.organ_acronym}]" if user.organ.present?
  end

end
