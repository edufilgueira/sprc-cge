class Transparency::PublicTickets::CommentsController < TransparencyController
  include ::PaginatedController

  before_action :require_user, except: [:index, :show]

  PERMITTED_PARAMS = [
    :description
  ]

  helper_method [
    :citizen_comments,
    :citizen_comment,
    :comment_form
  ]

  def create
    citizen_comment.ticket = ticket
    citizen_comment.user = current_user

    citizen_comment.save

    render partial: 'index'
  end

  private

  def citizen_comments
    paginated_citizen_comments
  end

  def citizen_comment
    resource
  end

  def comment_form
    ticket.citizen_comments.new
  end

  def resource_name
    'citizen_comment'
  end

  def ticket
    @ticket ||= Ticket.find(param_public_ticket_id)
  end

  def param_public_ticket_id
    params[:public_ticket_id]
  end

  def paginated_citizen_comments
    paginated(sorted_citizen_comments)
  end

  def ticket_citizen_comments
    ticket.citizen_comments
  end

  def sorted_citizen_comments
    ticket_citizen_comments.sorted
  end

  def require_user
    redirect_to new_user_session_path unless current_user.present?
  end
end
