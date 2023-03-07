module AnswersHelper

  def answer_description_text(user)
    I18n.t("shared.answers.form.description.#{answer_text_scoped(user)}")
  end

  def answer_save_text(user)
    I18n.t("shared.answers.form.save.#{answer_text_scoped(user)}")
  end

  def answer_types_for_select(ticket)
    answer_types_keys(ticket).map do |answer_type|
      [answer_type_title(answer_type), answer_type]
    end
  end

  def answer_class(answer)
    return 'alert-info' if answer.approved_for_user?

    case answer.status
    when /.*approved/
      'alert-success'
    when 'awaiting'
      'alert-info'
    when 'user_evaluated'
      answer_class_for_user_evaluated(answer)
    else
      'alert-danger'
    end
  end

  def answer_icon(answer)
    case answer.status
    when /.*approved/
      'fa-thumbs-up'
    when 'user_evaluated'
      'fa-answers-o'
    else
      'fa-thumbs-down'
    end
  end

  def answer_status(user)
    (user.sectoral? || user.internal? || user.subnet_sectoral?) ? :awaiting : :cge_approved
  end

  def answer_scope(user, ticket)
    case user.operator_type
    when 'internal'
      ticket.subnet? ? :subnet_department : :department
    when 'sou_sectoral', 'sic_sectoral'
      :sectoral
    when 'subnet_sectoral'
       :subnet
    else
      :cge
    end
  end

  def answer_subnet_responsible_from_log(ticket_log)
    subnet_id = ticket_log.data[:responsible_subnet_id]

    return unless subnet_id.present?

    Subnet.find(subnet_id)
  end

  def answer_organ_responsible_from_log(ticket_log)
    organ_id = ticket_log.data[:responsible_organ_id]

    return unless organ_id.present?

    Organ.find(organ_id)
  end

  def answer_department_responsible_from_log(ticket_log)
    department_id = ticket_log.data[:responsible_department_id]

    return unless department_id.present?

    Department.find(department_id)
  end

  def answer_positioning_departments_for_select(ticket)
    ticket.ticket_departments.not_answered.map do |td|
      department = td.department
      [department.title, department.id]
    end
  end

  def answer_active_by_ticket_department(ticket_department)
    ticket = ticket_department.ticket
    department = ticket_department.department

    ticket.answers.active.by_department(department.id).first
  end

  def permission_check_for_type(type)
    (type == 'letter' && can?(:answer_by_letter, current_user)) ||
    (type == 'phone' && can?(:answer_by_phone, current_user))
  end

  private

  def ticket_partial_answers_approved?(ticket)
    ticket.answers.approved.exists?(answer_type: :partial)
  end

  def answer_types_keys(ticket)
    types = Answer.answer_types

    if ticket.sic? || ticket_partial_answers_approved?(ticket)
      types = types.except(:partial)
    end

    types.keys
  end

  def answer_type_title(answer_type)
    Answer.human_attribute_name("answer_type.#{answer_type}")
  end

  def ticket_reopened_or_appeal_and_current_answer(ticket, answer)
    return (ticket.reopened + ticket.appeals == answer.version) if ticket.reopened? && ticket.appeals?
    ticket_appeal_and_current_answer(ticket, answer) || ticket_reopened_and_current_answer(ticket, answer)
  end

  def ticket_appeal_and_current_answer(ticket, answer)
    ticket.appeals? && ticket.appeals == answer.version
  end

  def ticket_reopened_and_current_answer(ticket, answer)
    ticket.reopened? && ticket.reopened == answer.version
  end

  def answer_class_for_user_evaluated(answer)
    ticket = answer.ticket
    (!ticket.reopened? && !ticket.appeals?) || ticket_reopened_or_appeal_and_current_answer(ticket, answer) ? 'alert-success' : 'alert-warning'
  end

  def answer_text_scoped(user)
    user.internal? ? 'internal' : 'default'
  end

  def verifid_parent_or_cosco_couvi(ticket, organ, answer, department, subnet)
    if (ticket.parent? && organ&.acronym.in?(Organ.organ_coordination)) || organ&.acronym.in?(Organ.organ_coordination)
      t(".title.sectoral.#{ticket.ticket_type}", type: answer.answer_type_str, organ: organ&.acronym, department: department&.acronym, subnet: subnet&.acronym, ouvidoria: nil)
    else
      t(".title.#{answer.answer_scope}.#{ticket.ticket_type}", type: answer.answer_type_str, organ: organ&.acronym, department: department&.acronym, subnet: subnet&.acronym, ouvidoria: "Ouvidoria")
    end
  end

  def answer_appeal_and_operator_cge_or_not_appeal(ticket, user)
    (ticket.internal_status == 'appeal' && operator_cge?(current_user)) || (ticket.internal_status != 'appeal')
  end

end

