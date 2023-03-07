class Operator::Tickets::ChangeSouTypesController < OperatorController
  include Operator::Tickets::ChangeSouTypes::Breadcrumbs

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

  helper_method [:ticket, :anonymous_param, :ticket_type]

  before_action :can_change_sou_type


  def create
    assign_attributes(ticket)

    if ensure_change_sou_valid?
      register_log_and_save
      redirect_to operator_ticket_path(ticket), notice: t('.done')
    else
      flash.now[:alert] = t('.fail')
      render :new
    end
  end

  # Helper methods

  def ticket
    @ticket ||= Ticket.find(params[:ticket_id])
  end

  def resource_params
    if params[:ticket].present?
      params.require(:ticket).permit(PERMITTED_PARAMS)
    end
  end

  def anonymous_param
    ticket.anonymous || params[:anonymous] == 'true'
  end

  def ticket_type
    :sou
  end

  private

  def ticket_parent
    @ticket_parent ||= ticket.parent || ticket
  end

  def assign_attributes(ticket)
    assign_ticket_attributes(ticket)
    if ticket.parent?
      ticket.tickets.each { |t| assign_ticket_attributes(t) }
    elsif no_denunciation_children?(ticket)
      assign_ticket_attributes(ticket_parent)
    end
  end

  def assign_ticket_attributes(ticket)
    ticket.assign_attributes(resource_params)
    build_description(ticket)
  end

  def no_denunciation_children?(ticket)
    !  ticket.parent.tickets.where.not(id: ticket.id).any?(&:denunciation?)
  end

  def ensure_change_sou_valid?
    ticket.sou_type_changed? && ticket.valid? && params[:justification].present?
  end

  def register_log_and_save
    register_change_sou_type_log
    ticket_parent.save
    ticket.save
  end

  def build_description(ticket)
    if ticket.sou_type_was == 'denunciation'
      ticket.description = ticket.denunciation_description
    elsif ticket.sou_type  == 'denunciation'
      ticket.denunciation_description = ticket.description
    end
  end

  def register_change_sou_type_log
    # A partial que renderiza os históricos pega sempre o parent do ticket.
    # Talvez isso seja feito para ter o log de criação da manifestação.
    #
    # Por isso, vamos registrar o log no parent e usar um data[:target_ticket_id]
    # para fazer referência ao ticket original (child) que pode teve seu
    # sou_type alterado.

    attributes = {
      description: params[:justification],

      data: {
        from: ticket.sou_type_was,
        to: ticket.sou_type,
        target_ticket_id: ticket.id
      }
    }

    RegisterTicketLog.call(ticket_parent, current_user, :change_sou_type, attributes)
  end

  def can_change_sou_type
    authorize! :change_sou_type, ticket
  end
end
