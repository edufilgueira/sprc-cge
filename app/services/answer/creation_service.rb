class Answer::CreationService < Answer::BaseService

  attr_reader :answer, :ticket, :parent_ticket, :responsible

  def self.call(answer, responsible)
    new(answer, responsible).call
  end

  def initialize(answer, responsible)
    @answer = answer
    @responsible = responsible
    @ticket = @answer.ticket
    @parent_ticket = @ticket.parent
  end

  def call
    ActiveRecord::Base.transaction do
      update_answer_for_sectoral if user_sectoral?

      update_answer_for_subnet if user_subnet_sectoral?

      update_ticket_classification

      update_ticket_status

      register_logs
    end

    notify
  end

  private

  def update_ticket_classification
    return if answer.department? || answer.subnet_department?
    ticket.update_attribute(:answer_classification, answer.classification)
  end

  def register_logs
    register_log(ticket)
    register_log(parent_ticket) if parent_ticket.present?
  end

  def register_log(resource)
    RegisterTicketLog.call(resource, responsible, :answer, { resource: answer, data: data_attributes })
    register_attachments_log(resource)
  end

  def register_attachments_log(resource)
    answer.attachments.each do |attachment|
      RegisterTicketLog.call(resource, responsible, :create_attachment, { resource: attachment })
    end
  end

  #
  # Importante o registro de usuário, órgão e unidade no momento da criação do log
  # Desta forma, se torna fácil a recuperação de dados históricos
  #
  # Sem isso não é possível recuperar o orgão apenas pelo ticket por exemplo, caso o ticket tenha sido transferido
  # A mesma coisa para usuário, sem esses dados terímaos apena a string do author sem referência ao usuário
  #
  def data_attributes
    {
      responsible_user_id: user_id,
      responsible_organ_id: organ_id,
      responsible_department_id: department_id,
      responsible_subnet_id: subnet_id
    }
  end

  def organ_id
    ticket.organ_id || ExecutiveOrgan.comptroller.id
  end

  def department_id
    user_department_id || ticket_department_email_department_id || answer.department_id
  end

  def subnet_id
    ticket.subnet_id || user_subnet_id
  end

  def notify
    Notifier::Answer.delay.call(answer.id, user_id)
  end

  def update_ticket_status
    if ticket.sou? && answer.partial? && user_cge_or_coordination?
      update_ticket_status_partial
    else
      update_ticket_status_final
    end
  end

  def update_ticket_status_final
    if answer.sectoral?
      update_ticket_for_sectoral
    elsif answer.department?
      update_ticket_for_internal
    elsif user_cge_or_coordination?
      update_ticket_for_cge
    elsif answer.subnet_department?
      update_ticket_for_subnet_internal
    elsif answer.subnet?
      update_ticket_subnet
    end

    if ticket.extensions.in_progress.present?
     ticket.extensions.update(status: :cancelled)
    end
  end

  def update_ticket_status_partial
    ticket.update_attributes(partial_answer_attributes)
    if all_active_children_partial_replied?
      parent_ticket.update_attributes(partial_answer_attributes)
    end
  end

  def update_ticket_for_cge
    if ticket.child?
      update_answer_to_cge_approved_status
    else
      ticket.update_attributes(cge_approved_statuses(ticket))
      ticket.tickets.active.update_all(cge_approved_statuses)
    end
  end

  def update_answer_to_cge_approved_status
    answer.cge_approved!
    ticket.update_attributes(cge_approved_statuses(ticket))

    parent_ticket.update_attributes(cge_approved_statuses(parent_ticket)) if all_active_children_replied?
  end

  def cge_approved_statuses(ticket = nil)
    params_approved = { status: :replied, internal_status: status_by_answer, responded_at: DateTime.now }

    if ticket.present? && ticket.parent? && (ticket.phone? || ticket.whatsapp?)
      params_approved.merge!({ call_center_status: :waiting_allocation })
    end

    params_approved
  end

  def status_by_answer
    answer.partial? ? :partial_answer : :final_answer
  end

  def all_active_children_replied?
    parent_ticket.present? && parent_ticket.tickets.active.all?(&:final_answer?)
  end

  def update_ticket_for_internal
    ticket_department&.update_attribute(:answer, :answered)
    ticket.sectoral_validation! if any_department_replied?
    update_answer_for_positioning if user_sectoral?
  end

  def update_ticket_for_subnet_internal
    ticket_department&.update_attribute(:answer, :answered)
    ticket.subnet_validation! if any_department_replied?
  end

  def update_answer_for_positioning
    answer.update_attributes({ answer_type: :final, status: :sectoral_approved  })
  end

  def any_department_replied?
    ticket.ticket_departments.exists?(answer: :answered)
  end

  def ticket_department
    ticket.ticket_departments.find_by(department_id: department_id)
  end

  def update_ticket_subnet
    if ticket.subnet_ignore_sectoral_validation || ticket.immediate_answer?
      sectoral_params = cge_approved_statuses(ticket)
      ticket.update_attributes(sectoral_params)

      cge_params = parent_sou_params
      ticket.parent.update_attributes(cge_params)
    else
      ticket.sectoral_validation!
      ticket.parent.sectoral_validation!
    end
  end

  def update_ticket_for_sectoral
    ticket.sou? ? update_ticket_sou_for_sectoral : update_ticket_sic_for_sectoral
  end

  def update_ticket_sic_for_sectoral
    update_answer_to_cge_approved_status
  end

  def update_ticket_sou_for_sectoral
    sectoral_params = ticket_sou_params
    ticket.update_attributes(sectoral_params)

    cge_params = parent_sou_params
    ticket.parent.update_attributes(cge_params)
  end

  def update_answer_for_sectoral
    answer.update_attributes(answer_sou_params)
  end

  def update_answer_for_subnet
    answer.update_attributes(status_for_subnet)
  end

  def status_for_subnet
    if ticket.subnet_ignore_sectoral_validation || ticket.immediate_answer?
      answer_cge_approved_status
    else
      answer_awaiting_status
    end
  end

  def ticket_sou_params
    if ticket.can_ignore_cge_validation? || ticket.subnet? || ticket.immediate_answer?
      cge_approved_statuses(ticket)
    else
      cge_validation_status
    end
  end

  def answer_sou_params
    if ticket.can_ignore_cge_validation? || ticket.subnet?
      answer_cge_approved_status
    elsif ticket.immediate_answer?
      immediate_answer_status
    else
      answer_awaiting_status
    end
  end

  def parent_sou_params
    if all_active_children_replied? || ticket.immediate_answer?
      cge_approved_statuses(ticket.parent)
    elsif all_active_children_partial_replied?
      partial_answer_attributes
    elsif any_children_cge_validation?
      cge_validation_status
    else
      {}
    end
  end

  def any_children_cge_validation?
    parent_ticket.present? && parent_ticket.tickets.active.any?(&:cge_validation?)
  end

  def responsible_user?
    responsible.is_a?(User)
  end

  def responsible_ticket_department_email?
    responsible.is_a?(TicketDepartmentEmail)
  end

  def user_cge_or_coordination?
    responsible_user? && (responsible.cge? || responsible.coordination?)
  end

  def user_sectoral?
    responsible_user? && responsible.sectoral?
  end

  def user_subnet_sectoral?
    responsible_user? && responsible.subnet_sectoral?
  end

  def ticket_department_email_department_id
    responsible.ticket_department.department_id if responsible_ticket_department_email?
  end

  def user_id
    responsible.id if responsible_user?
  end

  def user_department_id
    responsible.department_id if responsible_user?
  end

  def user_subnet_id
    responsible.subnet_id if responsible_user?
  end

  def partial_answer_attributes
    { internal_status: :partial_answer, responded_at: DateTime.now }
  end

  def cge_validation_status
    { internal_status: :cge_validation }
  end

  def answer_awaiting_status
    { status: :awaiting }
  end

  def answer_cge_approved_status
    { status: :cge_approved }
  end

  def immediate_answer_status
    {
      answer_scope: :sectoral,
      status: :cge_approved
    }
  end
end
