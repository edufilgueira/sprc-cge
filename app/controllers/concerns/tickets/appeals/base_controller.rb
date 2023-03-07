module Tickets::Appeals::BaseController
  extend ActiveSupport::Concern

  APPEAL_DEADLINE = 5

  PERMITTED_PARAMS = [
    :description
  ]

  included do

    before_action :can_appeal_ticket

    helper_method [:ticket_log, :ticket]

    def create
      clear_call_center_responsible(ticket)
      update_ticket_appeals

      if ticket_log.save
        update_ticket
        redirect_to_show_with_success && notify
      else
        set_error_flash_now_alert
        render :new
      end
    end

    # Helper methods

    def ticket_log
      @ticket_log ||= ticket.ticket_logs.build(resource_params)
    end

    def ticket
      @ticket ||= Ticket.find(params[:ticket_id])
    end

    private

    def resource_params
      if params[:ticket_log]
        params.require(:ticket_log).permit(PERMITTED_PARAMS).merge(action: :appeal, responsible: user, data: { count: ticket.appeals })
      end
    end

    def resource_klass
      TicketLog
    end

    def can_appeal_ticket
      authorize! :appeal, ticket
    end

    def update_ticket
      weekday = Holiday.next_weekday(APPEAL_DEADLINE)
      ticket.deadline = weekday
      ticket.deadline_ends_at = Date.today + weekday.days
      ticket.internal_status = :appeal

      update_children_attributes(ticket)

      ticket.status = :confirmed

      ticket.call_center_feedback_at = nil

      ticket.save!
    end

    def clear_call_center_responsible(ticket)
      ticket.call_center_responsible_id = nil
    end

    def update_ticket_appeals
      ticket.appeals += 1
      ticket.appeals_at = DateTime.now
    end

    def user
      current_user || current_ticket
    end

    def redirect_to_show
      redirect_to url_for([namespace, ticket, only_path: true])
    end

    def notify
      Notifier::Appeal.delay.call(ticket.id)
    end

    def update_children_attributes(parent_ticket)
      list_child_ids = parent_ticket.tickets.ids
      Ticket.where(id:list_child_ids).update(internal_status: :appeal, appeals: parent_ticket.appeals)
    end
  end
end
