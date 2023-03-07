module Api::Tickets::BaseController
  extend ActiveSupport::Concern
  include ::BaseController
  include ::Tickets::BaseController

  PER_PAGE = 20

  included do

    load_resource except: [:create, :update]
    authorize_resource

    def index
      object_index_response(paginated_tickets)
    end

    def create
      ticket.status = :confirmed
      ticket.ticket_type = ticket_type

      set_deadline && set_confirmed_at

      ticket.parent_unknown_organ = ticket.unknown_organ
      ticket.save!

      register_ticket_log :confirm

      if ticket.unknown_organ?
        ticket.waiting_referral!
      else
        ticket.sectoral_attendance!

        # Quando o chamado possuir órgão, será criado um chamado "filho"
        # com as informações do chamado que passará a ser o "pai" sem órgão
        ticket.create_ticket_child
      end

      object_response(accessible_ticket_response(ticket), :created)

      notify
    end

    def show
      object_response(ticket)
    end

    def update
      ticket.update!(resource_params)
      object_response(ticket)
    end


    # private


    private

    def per_page
      params[:per_page].present? ? params[:per_page] : self.class::PER_PAGE
    end

    def accessible_ticket_response(ticket)
      # usuário sempre ve o ticket pai
      return ticket.reload if current_user.user?

      # operador setorial sempre ve o ticket filho se existir o órgão
      ticket.tickets.present? ? ticket.tickets.first : ticket.reload
    end

    def tickets_from_ticked_type
      user_tickets.from_type(ticket_type)
    end

    def resource_params
      params.permit(self.class::PERMITTED_PARAMS)
    end
  end
end
