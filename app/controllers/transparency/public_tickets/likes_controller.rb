class Transparency::PublicTickets::LikesController < TransparencyController

  before_action :require_user, only: [:create, :destroy]

  helper_method :ticket_like

  def create
    ticket_like.save

    render partial: "form" if request.xhr?
  end

  def destroy
    ticket_like.destroy

    render partial: "form" if request.xhr?
  end

  def ticket_like
    @ticket_like ||= TicketLike.where(ticket_id: param_public_ticket_id, user: current_user).first_or_initialize
  end

  private

  def resource_name
    'ticket_like'
  end

  def ticket
    @ticket ||= Ticket.find(param_public_ticket_id)
  end

  def param_public_ticket_id
    params[:public_ticket_id]
  end

  def require_user
    redirect_to new_user_session_path unless current_user.present?
  end
end
