module ClassificationsHelper

  def topics_for_select(organ = nil)
    topics = sorted_topics.where(organ: [nil, organ])
    map_by_title(topics, true)
  end

  def subtopics_by_topic_for_select(topic)
    subtopics = sorted_subtopics.where(topic: topic)
    map_by_title(subtopics, true)
  end

  def sub_departments_for_select
    map_by_title(sorted_sub_departments)
  end

  def sub_departments_by_department_for_select(department)
    sub_departments = sorted_sub_departments.where(department: department)
    map_by_title(sub_departments)
  end

  def budget_programs_for_select(organ = nil, subnet = nil)
    budget_programs = budget_programs_by_organ_subnet(organ, subnet)

    map_by_title(budget_programs, true)
  end

  def service_types_for_select(organ = nil, subnet = nil)
    service_types =
      if subnet.present?
        sorted_service_types.where('organ_id IS NULL OR subnet_id = ?', subnet)
      else
        sorted_service_types.where(organ: [nil, organ])
      end

    map_by_title(service_types, true)
  end

  def classifications_sub_departments_by_user_for_select(user)
    sub_departments = sorted_sub_departments
    map_by_title(sub_departments_by_user(sub_departments, user))
  end

  private

  def sorted_topics
    Topic.not_other_organs.without_no_characteristic.sorted
  end

  def sorted_subtopics
    Subtopic.not_other_organs.sorted
  end

  def sorted_sub_departments
    SubDepartment.enabled.sorted
  end

  def sorted_budget_programs
    BudgetProgram.not_other_organs.without_no_characteristic.enabled.sorted
  end

  def sorted_service_types
    ServiceType.not_other_organs.enabled.sorted
  end

  def budget_programs_by_organ_subnet(organ, subnet)
    budget_programs = sorted_budget_programs

    return budget_programs.where(organ: [nil, organ], subnet: nil) if organ

    return  budget_programs.where(organ: nil, subnet: [nil, subnet]) if subnet

    return budget_programs
  end

  def sub_departments_by_user(sub_departments, user)
    return sub_departments.where(department: user.department) if user.internal?

    return sub_departments.joins(:department).where("departments.organ_id = #{user.organ.id}") if user.sectoral?

    return user.subnet.sub_departments if user.subnet.present?

    sub_departments
  end

  def map_by_title(resources, has_other_organs = false)
    resources.map do |r|
      array = [r.title, r.id]

      array.push({ other_organs: r.other_organs }) if has_other_organs

      array
    end
  end
end
