class Answer::RejectionService < Answer::BaseService

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

      update_ticket_departments

      update_ticket_logs
    end

    notify
  end

  private

  def answer_status
    case user.operator_type
    when 'cge'
      :cge_rejected
    when 'subnet_sectoral'
      :subnet_rejected
    else
      :sectoral_rejected
    end
  end

  def update_tickets
    if answer.cge_rejected?
      ticket.update_attributes({ internal_status: cge_rejected_status })
      parent_ticket.update_attributes({ internal_status: cge_rejected_status })
    elsif answer.subnet?
      ticket.subnet_attendance!
    else
      ticket.internal_attendance!
    end
  end

  def update_ticket_departments
    if user.cge? || answer.subnet?
      ticket_departments.update_all(answer: :not_answered)
    else
      ticket_department&.update_attribute(:answer, :not_answered)
    end
  end

  def ticket_departments
    ticket.ticket_departments
  end

  def ticket_department
    ticket_departments.find_by(department_id: department_id)
  end

  def department_id
    ticket_log&.data[:responsible_department_id]
  end

  def notify
    Notifier::Answer.delay.call(answer.id, user.id)
    notify_additional_users
  end

  def notify_additional_users
    return if user.cge? || ticket_department.blank?

    ticket_department_emails.pluck(:email).uniq.each do |email|
      created = ticket_department_emails.create(email: email)
      Notifier::Referral::AdditionalUserRejected.delay.call(ticket.id, created.id, user.id, justification)
    end
  end

  def ticket_department_emails
    ticket_department.ticket_department_emails
  end

  def cge_rejected_status
    return :partial_answer if ticket_has_partial_answer_approved?
    answer.subnet? ? :subnet_attendance : :sectoral_attendance
  end

  def ticket_has_partial_answer_approved?
    ticket.answers.approved.partial.exists?(version: ticket.reopened)
  end
end
