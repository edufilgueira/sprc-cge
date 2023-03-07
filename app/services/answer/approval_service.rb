class Answer::ApprovalService < Answer::BaseService

  attr_reader :answer, :user, :justification, :ticket, :parent_ticket

  def self.call(answer, user, justification)
    new(answer, user, justification).call
  end

  def initialize(answer, user, justification)
    @answer = answer
    @justification = justification
    @user = user
    @ticket = @answer.ticket
    @parent_ticket = @ticket.parent
  end

  def call
    ActiveRecord::Base.transaction do
      update_answer

      update_tickets

      update_ticket_logs
    end

    notify
  end

  private

  def answer_status
    return :cge_approved if user.cge? || user.coordination?
    return :subnet_approved if user.subnet_sectoral?

    if answer.subnet?
      :cge_approved
    else
      :sectoral_approved
    end
  end

  def update_tickets
    if answer.cge_approved?
      ticket.update_attributes(approved_statuses)
      update_ticket_cge_approved_statuses
    end
  end

  def approved_statuses(resource = nil)
    params_approved = { status: :replied, internal_status: ticket_internal_status(resource), responded_at: DateTime.now }

    if resource_parent_and_phone_or_whatsapp?(resource) && answer.final?
      params_approved.merge!({ call_center_status: :waiting_allocation })
    end

    params_approved
  end

  def resource_parent_and_phone_or_whatsapp?(resource)
    resource&.parent? && (resource.phone? || resource.whatsapp?)
  end

  def ticket_internal_status(resource)
    return parent_internal_status if resource.present?

    answer.final? ? :final_answer : :partial_answer
  end

  def parent_internal_status
    all_active_children_final_replied? ? :final_answer : :partial_answer
  end

  def update_ticket_cge_approved_statuses
    parent_ticket.update_attributes(params_cge_update)
  end

  def params_cge_update
    return approved_statuses(parent_ticket) if all_active_children_final_or_partial_replied?
    return cge_validation_status if any_active_children_validation?

    cge_sectoral_statuses
  end

  def all_active_children_final_or_partial_replied?
    all_active_children_final_replied? || all_active_children_partial_replied?
  end

  def all_active_children_final_replied?
    parent_ticket.tickets.active.all?(&:final_answer?)
  end

  def any_active_children_validation?
    parent_ticket.tickets.active.any?(&:cge_validation?)
  end

  def cge_validation_status
    { internal_status: :cge_validation }
  end

  def cge_sectoral_statuses
    { internal_status: :sectoral_attendance }
  end

  def notify
    Notifier::Answer.delay.call(answer.id, user.id)
  end
end
