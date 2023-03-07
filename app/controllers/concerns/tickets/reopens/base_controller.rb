module ::Tickets::Reopens::BaseController
  extend ActiveSupport::Concern

  PERMITTED_PARAMS = [
    :description
  ]

  included do

    before_action :can_reopen_ticket

    helper_method [:ticket_log, :ticket, :organ]


    def create
      clear_call_center_responsible(ticket)
      update_ticket_reopened(ticket)

      if ticket_log.save
        update_ticket
        register_parent_ticket_log
        notify
        redirect_to_show_with_success
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

    def organ
      # a resposta pode ser enviada diretamento pela CGE sem encaminhamento
      @organ ||= ticket.organ || Organ.find_by(acronym: 'CGE')
    end

    private

    def resource_params
      if params[:ticket_log]
        params.require(:ticket_log).permit(PERMITTED_PARAMS).merge(action: :reopen, responsible: user, data: { count: ticket.reopened })
      end
    end

    def resource_klass
      TicketLog
    end

    def ticket_parent
      ticket.parent || ticket
    end

    def can_reopen_ticket
      authorize! :reopen, ticket
    end

    def update_ticket
      reopen_ticket(ticket)
      if ticket.child?
        reopen_ticket(ticket_parent)
        reopen_ticket_departments
      end
    end

    def clear_call_center_responsible(ticket)
      ticket.call_center_responsible_id = nil
    end

    def update_ticket_reopened(ticket)
      ticket.reopened += 1
      ticket.reopened_at = DateTime.now
      ticket.extended = false
      ticket.extended_second_time = false
      ticket.set_deadline

      update_ticket_reopened(ticket.parent) if ticket.child?
    end

    def reopen_ticket(ticket)
      ticket.internal_status = internal_status(ticket)
      ticket.status = :confirmed

      ticket.call_center_feedback_at = nil

      ticket.save(validate: false)
    end

    def register_parent_ticket_log
      ticket_parent.ticket_logs.create(resource_params) if ticket.child?
    end

    def notify
      Notifier::Reopen.delay.call(ticket.id)
    end

    def user
      current_user || current_ticket
    end

    def redirect_to_show
      t = can_see_parent? ? ticket_parent : ticket
      redirect_to url_for([namespace, t, only_path: true])
    end

    def reopen_ticket_departments
      ticket.ticket_departments.update_all(answer: :not_answered)
    end

    def internal_status(ticket)
      return internal_status_for_parent(ticket) if ticket.parent?

      :sectoral_attendance
    end

    def internal_status_for_parent(ticket)
      ticket.tickets.active.blank? ? :waiting_referral : :sectoral_attendance
    end

    def can_see_parent?
      ticket.parent.present? && can?(:show, ticket_parent)
    end

    def set_success_flash_notice
      flash[:notice] = t(".#{ticket.ticket_type}.done", title: resource_notice_title)
    end

    def set_error_flash_alert
      flash[:alert] = t(".#{ticket.ticket_type}.error", title: resource_notice_title)
    end

    def set_error_flash_now_alert
      flash.now[:alert] = t(".#{ticket.ticket_type}.error", title: resource_notice_title)
    end
  end
end
