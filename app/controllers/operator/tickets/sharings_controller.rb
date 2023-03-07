class Operator::Tickets::SharingsController < OperatorController
  include Operator::Tickets::Sharings::Breadcrumbs

  before_action :can_share_ticket, only: [ :create, :new ]

  before_action :can_delete_share_ticket, only: [ :destroy ]

  helper_method [:ticket, :ticket_parent, :title]

  PERMITTED_PARAMS = [ tickets_attributes: Ticket::PERMITTED_PARAMS_FOR_SHARE ]


  # Actions

  def create
    if Ticket::Sharing.call(sharing_params)
      redirect_to operator_ticket_path(ticket), notice: t('.done')
    else
      # precisa disso para exibir os erros no form
      assign_attributes_and_validate_ticket_parent

      flash.now[:alert] = t('.fail')
      render :new
    end
  end

  # Helper methods

  def ticket
    @ticket ||= Ticket.find(params[:ticket_id])
  end

  def ticket_parent
    @ticket_parent = ticket.parent || ticket
  end

  def title
    t(".#{ticket.ticket_type}.title.#{title_type}", protocol: ticket.parent_protocol)
  end


  # Private

  private

  def resource_params
    if params[:ticket]
      params.require(:ticket).permit(PERMITTED_PARAMS)
    end
  end

  def ticket_attributes
    return {} if resource_params.blank?
    resource_params[:tickets_attributes]
  end

  def sharing_params
    {
      ticket_id: ticket.id,
      current_user_id: current_user.id,
      new_tickets_attributes: ticket_attributes
    }
  end

  def title_type
    ticket.child? ? :share : :add
  end

  def assign_attributes_and_validate_ticket_parent
    ticket_parent.assign_attributes(resource_params)
    ticket_parent.validate
  end

  def can_share_ticket
    authorize! :share, ticket
  end

  def can_delete_share_ticket
    authorize! :delete_share, ticket
  end

  def resource_destroy
    Ticket::DeleteSharing.call(params[:ticket_id], current_user.id)
  end

  def redirect_to_index_with_success
    flash[:notice] = t('.destroy.done')
    redirect_to_sharing
  end

  def redirect_to_index_with_error
    flash[:notice] = t('.destroy.fail')
    redirect_to_sharing
  end

  def redirect_to_sharing
    redirect_to new_operator_ticket_sharing_path(ticket_parent)
  end
end
