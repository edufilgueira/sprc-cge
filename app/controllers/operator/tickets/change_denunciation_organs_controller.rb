class Operator::Tickets::ChangeDenunciationOrgansController < OperatorController
  include Operator::Tickets::ChangeDenunciationOrgans::Breadcrumbs

  PERMITTED_PARAMS = [ :denunciation_organ_id ]

  helper_method [:ticket]

  before_action :can_change_denunciation_organ

  def create
    ticket.assign_attributes(resource_params)

    if ticket.save
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

  private

  def resource_name
    'ticket'
  end

  def can_change_denunciation_organ
    authorize! :edit_denunciation_organ, ticket
  end
end
