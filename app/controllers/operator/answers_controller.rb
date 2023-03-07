class Operator::AnswersController < OperatorController
  include ::Tickets::Answers::BaseController

  FIND_ACTIONS = FIND_ACTIONS + ['approve_answer', 'reject_answer']

  PERMITTED_PARAMS = Answer::OPERATOR_PERMITTED_PARAMS + [:department_id]

  # Callbacks

  before_action :assign_user,
    :default_attributes,
    :clone_attachments,
    only: :create


  # Public

  def create
    ActiveRecord::Base.transaction do
      if ensure_custom_errors && answer.save
        Answer::CreationService.call(answer, current_user)
      else
        copy_answer_to_new_answer
      end

      render_ticket_logs
    end
  end

  def approve_answer
    if answer.update_attributes(permitted_answer_params)
      Answer::ApprovalService.call(answer, current_user, justification)
    end

    render_ticket_logs
  end

  def reject_answer
    if ensure_justification && answer.update_attributes(permitted_answer_params)
      Answer::RejectionService.call(answer, current_user, justification)
    end

    render_ticket_logs
  end


  ## Helpers

  def ticket
    return answer.ticket unless params[:ticket_id].present?
    Ticket.find(params[:ticket_id])
  end

  def answer_form_url
    [:operator, new_answer]
  end

  def new_answer
    @new_answer ||= Answer.new(ticket: ticket, description: new_answer_description)
  end

  def new_answer_description
    return unless current_user.sectoral? && approved_positionings.present?
    approved_positionings.last.description
  end

  def justification
    params[:answer][:justification]
  end

  private

  def assign_user
    answer.user = current_user
  end

  def ticket_parent
    ticket.parent || ticket
  end

  def ticket_answers
    ticket.answers
  end

  def ticket_positionings
    ticket_answers.department
  end

  def approved_positionings
    ticket_positionings.approved
  end

  def clone_attachments
    return unless params[:clone_attachments].present?

    params[:clone_attachments].each do |attachment_id|
      existent = Attachment.find(attachment_id)
      answer.attachments << existent.dup
    end
  end

  def default_attributes
    answer.version = answer_version
    default_answer_attributes_for_sectoral if answer.sectoral?
    default_answer_attributes_for_internal if answer.department? || answer.subnet_department?
  end

  def default_answer_attributes_for_sectoral
    answer.status = :cge_approved if ticket.can_ignore_cge_validation?
  end

  def default_answer_attributes_for_internal
    answer.status = :awaiting
    answer.answer_type = :final
  end

  def ensure_custom_errors
    ensure_answer_attachment_letter && ensure_department_id
  end

  def ensure_answer_attachment_letter
    return true unless ticket.letter?

    answer.positioning? || answer.attachments.present? || add_answer_letter_error_and_return_false
  end

  def ensure_department_id
    return true unless answer.department? && current_user.sectoral?

    answer.department_id.present? || add_answer_department_id_error
  end

  def add_answer_department_id_error
    answer.errors.add(:department_id, :blank)

    false
  end

  def add_answer_letter_error_and_return_false
    attachment = answer.attachments.build
    attachment.errors.add(:document, :attachment_letter)

    false
  end

  def ensure_justification
    justification.present? || add_justification_error_and_return_false
  end

  def add_justification_error_and_return_false
    answer.valid?
    answer.errors.add(:justification, :blank)

    false
  end

  def permitted_answer_params
    if params[:answer]
      params.require(:answer).permit(:answer_type, :classification, :description, :justification)
    end
  end

  def answer_version
    ticket_parent.appeals_at.blank? ? ticket.reopened : ticket.appeals
  end
end
