module ::Tickets::ChangeTypes::BaseController
  extend ActiveSupport::Concern

  PERMITTED_PARAMS = [
    :sou_type,
    :denunciation_organ_id,
    :denunciation_description,
    :denunciation_date ,
    :denunciation_place ,
    :denunciation_witness,
    :denunciation_evidence,
    :denunciation_assurance
  ]

  included do
    helper_method [:ticket, :ticket_original_type, :namespace]

    # Callbacks

    before_action :can_change_ticket_type

  # Actions

    def create
      @ticket_type_from = parent_ticket.ticket_type
      @sou_type_from = parent_ticket.sou_type

      if ChangeTicketType.call(parent_ticket, resource_params)
        register_log && notify
        if current_user.operator?
          redirect_to operator_ticket_path(ticket), notice: t('shared.tickets.change_types.create.done')
        else
          redirect_to platform_ticket_path(ticket), notice: t('shared.tickets.change_types.create.done')
        end
      else
        flash.now[:alert] = t('shared.tickets.change_types.create.fail')
        render :new
      end
    end

    # Helper methods

    def ticket
      @ticket ||= Ticket.find(params[:ticket_id])
    end

    def ticket_original_type
      @ticket_original_type ||= Ticket.select('ticket_type').find(params[:ticket_id]).ticket_type
    end


    # privates

    private

    def resource_params
      if params[:ticket].present?
        params.require(:ticket).permit(PERMITTED_PARAMS)
      end
    end

    def can_change_ticket_type
      authorize! :change_type, ticket
    end

    def notify
      Notifier::ChangeTicketType.delay.call(parent_ticket.id)
    end

    def register_log
      attributes = {
        data: {
          responsible_as_author: current_user.as_author,
          from: from,
          to: to
        }
      }

      RegisterTicketLog.call(parent_ticket, current_user, :change_ticket_type, attributes)
    end

    def from
      @ticket_type_from == 'sic' ? @ticket_type_from : @sou_type_from
    end

    def to
      ticket.reload

      ticket.ticket_type == 'sic' ? ticket.ticket_type.to_s : ticket.sou_type.to_s
    end

    def parent_ticket
      ticket.parent || ticket
    end

    def namespace
      current_user.operator? ? 'operator' : 'platform'
    end
  end
end
