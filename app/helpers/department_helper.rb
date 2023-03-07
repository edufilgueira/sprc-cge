module DepartmentHelper
  def departments_by_organ_for_select(organ)
    departments_by_organ(organ).map { |d| [d.title, d.id] }.to_h
  end

  def departments_by_subnet_for_select(subnet)
    departments_by_subnet(subnet).map { |d| [d.title, d.id] }.to_h
  end

  def departments_for_select
    sorted_departments.map { |d| [d.title, d.id] }.to_h
  end

  def departments_sorted_by_organ_for_select
    sorted_departments_organs.map { |d| [d.title, d.id] }.to_h
  end

  def acronym_departments_list(ticket)
    return ticket.subnet_acronym if ticket.subnet?
    ticket.ticket_departments.map(&:title_for_sectoral).sort.join("; ")
  end

  def departments_by_ticket_for_select(ticket)
    return departments_by_subnet_for_select(ticket.subnet) if ticket.subnet.present?
    return departments_by_organ_for_select(ticket.organ) if ticket.organ.present?

    departments_for_select
  end

  def departments_by_user_for_select(user)
    return departments_by_subnet_for_select(user.subnet) if user.subnet.present?
    return departments_by_organ_for_select(user.organ) if user.organ.present?

    departments_for_select
  end

  def departments_for_referral_for_select(ticket, user)
    departments_by_subnet_or_organ(ticket, user).map { |d| [d.title, d.id] }.to_h
  end

  def department_by_id_for_select(department_id)
    department = Department.find_by_id(department_id)

    return [] if department.nil?

    [[department.title, department.id]].to_h
  end


  private

  def departments_by_organ(organ)
    sorted_departments.where(organ: organ)
  end

  def departments_by_subnet(subnet)
    sorted_departments.where(subnet: subnet)
  end

  def sorted_departments
    Department.without_no_characteristic.enabled.sorted
  end

  def sorted_departments_organs
    Department.without_no_characteristic.enabled.sorted_by_organ
  end

  def departments_by_subnet_or_organ(ticket, user)
    return departments_by_subnet(ticket.subnet) if user.subnet_operator? || user.subnet_internal?

    return sorted_departments.where(organ: ticket.organ) unless ticket.subnet?

    departments_by_organ(ticket.subnet.organ).or(departments_by_subnet(ticket.subnet))
  end
end
