module SubDepartmentsHelper

  def sub_department_by_id_for_select(sub_department_id)
    sub_department = SubDepartment.find_by_id(sub_department_id)

    return [] if sub_department.nil?

    [[sub_department.title, sub_department.id]].to_h
  end
end
