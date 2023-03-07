module Attachments::BaseController
  extend ActiveSupport::Concern

  included do
    before_action :can_destroy_attachment
  end

  def destroy
    if resource_destroy
      register_logs
      redirect_to_index_with_success
    else
      redirect_to_index_with_error
    end
  end

  def attachment
    resource
  end

  private

  def register_logs
    register_log(ticket)
    register_log(ticket.parent) if ticket.child?
  end

  def register_log(ticket)
    RegisterTicketLog.call(ticket, user, :destroy_attachment, { data: { title: attachment.document_filename }})
  end

  def user
    current_user || current_ticket
  end

  def redirect_to_index_with_success
    set_success_flash_notice
    redirect_to_ticket
  end

  def redirect_to_index_with_error
    set_error_flash_alert
    redirect_to_ticket
  end

  def redirect_to_ticket
    redirect_to send("#{namespace}_ticket_path", ticket)
  end

  def ticket
    @ticket ||= Ticket.find(params[:ticket_id])
  end

  def attachmentable
    resource.attachmentable
  end

  def can_destroy_attachment
    authorize! :destroy, attachment
  end
end
