class PositioningsController < ApplicationController

  PERMITTED_PARAMS = [
    answer_attributes: [
      :description,

      attachments_attributes: [
        :document
      ]
    ]
  ]

  helper_method [
    :ticket_department_email,
    :ticket_department,
    :ticket
  ]

  def edit
    set_flash_already_positioned_and_redirect_to_show unless ticket_department_email.active? && ticket.active?
    ticket_department_email.build_answer
  end

  def update
    ActiveRecord::Base.transaction do
      if ticket_department_email.update_attributes(resource_params)
        invalidate_tokens

        Answer::CreationService.call(ticket_department_email.answer, ticket_department_email)

        redirect_to_show_with_success
      else
        set_error_flash_now_alert
        render :edit
      end
    end 
  end

  def ticket_department_email
    resource
  end

  def ticket_department
    ticket_department_email.ticket_department
  end

  def ticket
    ticket_department.ticket
  end

  def current_ability
    @current_ability ||= Abilities::User.factory(nil)
  end

  private

  def find_resource
    TicketDepartmentEmail.find_by!(token: params[:id])
  end

  def redirect_to_show
    redirect_to positioning_path(ticket_department_email.token)
  end

  def set_flash_already_positioned_and_redirect_to_show
    flash[:alert] = t('.already_positioned')
    redirect_to_show
  end

  def resource_params
    if params[:ticket_department_email]
      permitted = params.require(:ticket_department_email).permit(self.class::PERMITTED_PARAMS)
      permitted[:answer_attributes].merge!(default_answer_attributes)
      permitted
    end
  end

  def default_answer_attributes
    {
      answer_type: :final,
      answer_scope: default_answer_scope,
      status: :awaiting,
      ticket_id: ticket.id
    }
  end

  def default_answer_scope
    ticket.subnet? ? :subnet_department : :department
  end

  def invalidate_tokens
    ticket_department.ticket_department_emails.update_all(active: false)
  end

  def update_ticket
    ticket_department.update_attribute(:answer, :answered)
    ticket.sectoral_validation! if all_department_replied?
  end

  def all_department_replied?
    !ticket.ticket_departments.exists?(answer: :not_answered)
  end
end
