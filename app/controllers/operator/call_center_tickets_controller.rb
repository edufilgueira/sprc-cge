class Operator::CallCenterTicketsController < OperatorController
  include Operator::CallCenterTickets::Breadcrumbs
  include ::FilteredController
  include ::PaginatedController
  include ::SortedController

  FILTERED_COLUMNS = [
    :call_center_responsible_id,
    :priority,
    :parent_protocol
  ]

  FILTERED_ENUMS = [
    :ticket_type,
    :answer_type,
    :call_center_status
  ]

  SORT_COLUMNS = {
    created_at: 'tickets.created_at',
    deadline: 'tickets.deadline',
    call_center_allocation_at: 'tickets.call_center_allocation_at',
    name: 'tickets.name'
  }

  FIND_ACTIONS = FIND_ACTIONS + ['feedback']

  PER_PAGE = 20

  PERMITTED_PARAMS = [:call_center_responsible_id]

  helper_method [
    :tickets, :ticket, :permitted_params, :comment,
    :justification, :readonly?, :new_evaluation
  ]

  # Callbacks

  before_action :default_filter, only: :index

  # Actions

  def update_checked
    checked_resources.update_all(checked_tickets_attributes) if checked_resources.present?

    notify

    redirect_to operator_call_center_tickets_path(params: permitted_params)
  end

  def feedback
    ticket.call_center_feedback_at = DateTime.now
    ticket.with_feedback!

    register_ticket_log

    flash[:notice] = t('.done', date: formatted_feedback)
    redirect_to operator_call_center_ticket_path(ticket)
  end

  def tickets
    paginated_tickets
  end

  def ticket
    resource
  end

  def permitted_params
    params.permit([:ticket_type, :organ]).to_h
  end

  def comment
    # buildamos um novo comentário para ser usado no form do show.

    @comment ||= Comment.new(commentable: ticket)
  end

  def justification; end

  def readonly?
    false
  end

  def new_evaluation
    @new_evaluation ||= Evaluation.new(evaluation_type: :call_center)
  end

  private

  def resource_klass
    Ticket
  end

  def resources
    scope = current_user.call_center_supervisor? ? resource_klass : current_user.call_center_tickets
    scope.with_phone_or_whatsapp.final_answer.parent_tickets
  end

  def paginated_tickets
    paginated(filtered_tickets)
  end

  def sorted_resources
    filtered_tickets
  end

  def filtered_tickets
    filtered = sorted_tickets
    filtered = filtered_by_organ(filtered)

    filtered(Ticket, filtered)
  end

  def sorted_tickets
    resources.sorted(sort_column, sort_direction)
  end

  def default_sort_column
    'tickets.call_center_allocation_at'
  end

  def default_sort_direction
    :asc
  end

  def resource_params
    if params[:ticket]
      params.require(:ticket).permit(PERMITTED_PARAMS)
    end
  end

  def filtered_by_organ(scope)
    return scope unless params[:organ].present?
    scope.with_organ(params[:organ])
  end

  def default_filter
    if current_user.call_center_supervisor?
      params[:call_center_responsible_id] ||= '__is_null__'
      params[:call_center_status] ||= 'waiting_allocation'
    end

    params[:call_center_status] ||= 'waiting_feedback'
  end

  def formatted_feedback
    l(resource.call_center_feedback_at, format: :short)
  end

  def notify
    return unless param_checked_tickets.present? && ticket.call_center_responsible_id.present?

    checked_resources.each do |ticket|
      Notifier::AttendanceAllocation.delay.call(ticket.id, ticket.call_center_responsible_id)
    end
  end

  def param_checked_tickets
    params[:checked_tickets]&.reject(&:blank?)
  end

  def checked_resources
    resources.where(id: param_checked_tickets)
  end

  def checked_tickets_attributes
    params_update = {
      call_center_allocation_at: DateTime.now,
      call_center_status: :waiting_feedback
    }

    resource_params.to_h.merge(params_update)
  end

  def register_ticket_log
    RegisterTicketLog.call(ticket, current_user, :attendance_finalized)
  end
end
