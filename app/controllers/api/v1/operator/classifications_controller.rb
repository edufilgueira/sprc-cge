class Api::V1::Operator::ClassificationsController < OperatorController
  include Api::Classifications::BaseController

  skip_before_action :authenticate_enabled_user,
                     :require_operator, :only => [:topics]

  def topics
    topics = filter_objects(Topic, organ || denunciation_organ)

    if params[:paginate] == 'false'
      object_response(map_by_title_unpaginated(topics))
    else
      response_paginated(topics)
    end
  end

  def subtopics
    subtopics = filter_subtopics
    response_paginated(subtopics)
  end

  def departments
    departments = filter_departments
    response_paginated(departments)
  end

  def sub_departments
    sub_departments = filter_sub_departments(department, organ)
    response_paginated(sub_departments)
  end

  def service_types
    service_types = filter_objects(ServiceType, organ, subnet)
    response_paginated(service_types)
  end

  def budget_programs
    budget_programs = filter_budget_programs
    response_paginated(budget_programs)
  end

  private

  def map_by_title_unpaginated(resources)
    resources.map do |r|
      { name: r.title, id: r.id }
    end
  end

  def objects_search_by_name_acronym_organ(scope)
    scope.left_joins(:organ, :subnet)
      .where("LOWER(organs.acronym) LIKE LOWER(?) OR
        LOWER(subnets.acronym) LIKE LOWER(?) OR
        LOWER(departments.name) LIKE LOWER(?) OR
        LOWER(departments.acronym) LIKE LOWER(?)",
        "%#{search_param}%", "%#{search_param}%", "%#{search_param}%", "%#{search_param}%")
      .order("acronym, name")
  end

  def objects_search_by_name_acronym_department(scope)
    scope.left_joins(:department)
      .where("LOWER(departments.acronym) LIKE LOWER(?) OR
        LOWER(sub_departments.name) LIKE LOWER(?) OR
        LOWER(sub_departments.acronym) LIKE LOWER(?)",
        "%#{search_param}%", "%#{search_param}%", "%#{search_param}%")
      .order("acronym, name")
  end

  def subtopics_search_by_name(scope)
    scope.where("LOWER(name) LIKE LOWER(?)", "%#{search_param}%").order("name")
  end

  def departments_for_select(organ)
    departments_mapped = map_by_title(sorted_departments_by_organ(organ))

    blank_option.merge(departments_mapped)
  end

  def sub_departments_for_select
    sub_departments_mapped = map_by_title(sorted_sub_departments)

    blank_option.merge(sub_departments_mapped)
  end

  def filter_departments
    scope = departments_by(organ, subnet)
    scope = objects_search_by_name_acronym_organ(scope) if search_param.present?
    scope.enabled.sorted
  end

  def filter_budget_programs
    scope = budget_programs_by(organ)
    scope = budget_programs_not_other_organs(scope)
    scope = budget_programs_search_by_name_organ(scope) if search_param.present?
    scope.enabled.sorted
  end

  def budget_programs_search_by_name_organ(scope)
    scope.left_joins(:organ, :subnet)
      .where("LOWER(organs.acronym) LIKE LOWER(?) OR
        LOWER(subnets.acronym) LIKE LOWER(?) OR
        LOWER(budget_programs.name) LIKE LOWER(?)",
        "%#{search_param}%", "%#{search_param}%", "%#{search_param}%")
      .order("organs.name, name")
  end

  def budget_programs_by(organ)
    return sorted_budget_programs_without_organ_subnet if organ.blank?

    BudgetProgram.left_joins(:subnet).where("budget_programs.organ_id = :organ_id OR
      budget_programs.organ_id is NULL OR
      subnets.organ_id = :organ_id", organ_id: organ)
  end

  def budget_programs_not_other_organs(scope)
    scope.not_other_organs
  end

  def filter_sub_departments(department, organ)
    scope = sub_departments_by(department, organ)

    scope = objects_search_by_name_acronym_department(scope) if search_param.present?
    scope
  end

  def filter_subtopics
    scope = subtopics_by(topic)
    scope = subtopics_search_by_name(scope) if search_param.present?
    scope
  end

  def departments_by(organ, subnet)
    return sorted_departments if organ.blank? && subnet.blank?

    return sorted_departments.where(subnet: subnet) if subnet.present?

    sorted_departments.where(organ: organ)
  end

  def sub_departments_by(department, organ)
    return SubDepartment.where(department: department).enabled.sorted unless department.blank?

    unless organ.blank?
      return SubDepartment.joins(:department).where(departments: { organ: organ }).enabled.sorted
    end

    sorted_sub_departments
  end

  def subtopics_by(topic)
    Subtopic.not_other_organs.where(topic: topic).enabled.sorted
  end

  def sorted_sub_departments
    SubDepartment.enabled.sorted
  end

  def sorted_budget_programs_without_organ_subnet
    BudgetProgram.without_no_characteristic
      .where(organ: nil, subnet: nil).enabled.sorted
  end

  def sorted_departments
    Department.without_no_characteristic.enabled.sorted
  end

  def sorted_budget_programs
    BudgetProgram.without_no_characteristic.enabled.sorted
  end

  def department
    params[:classification_department] || params[:department]
  end

  def subnet
    params[:subnet]
  end

  def topic
    params[:topic]
  end

  def organ
    params[:organ]
  end
end
