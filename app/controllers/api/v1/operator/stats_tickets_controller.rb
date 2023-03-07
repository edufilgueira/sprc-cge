class Api::V1::Operator::StatsTicketsController < OperatorController

  PERMMITED_PARAMS = [
    :ticket_type,
    :month_start,
    :month_end,
    :year,
    :organ_id,
    :subnet_id
  ]

  def require_operator
    #
    # Overriding pois admin pode operar nesta API
    #
    redirect_to new_user_session_path unless current_user.operator? || current_user.admin?
  end

  def status
    render json: json_status
  end

  def create
    if created?
      render_success_json
    else
      render_error_json
    end
  end

  private

  def resource_params
    if params[:stats_ticket]
      params.require(:stats_ticket).permit(PERMMITED_PARAMS)
    end
  end

  def ensure_params
    new_params = resource_params
    new_params[:organ_id] ||= nil
    new_params[:subnet_id] ||= nil

    new_params
  end

  def stats_ticket
    @stats_ticket ||= Stats::Ticket.find_or_create_by(ensure_params)
  end

  def json_status
    Stats::Ticket.find(params['id']).to_json(only: [:status])
  end

  def created?
    stats_ticket.started! && update_stats_ticket
  end

  def render_success_json
    render json: json_create_success, status: :created
  end

  def render_error_json
    render json: json_create_error, status: :error
  end

  def json_create_success
    {
      path: status_api_v1_operator_stats_ticket_path(stats_ticket),
      status: stats_ticket.status
    }
  end

  def json_create_error
    { errors: stats_ticket.errors.messages }
  end

  def update_stats_ticket
    UpdateStatsTicketWorker.perform_async(stats_ticket.ticket_type, stats_ticket.year, stats_ticket.month_start, stats_ticket.month_end, stats_ticket.organ_id, stats_ticket.subnet_id)
  end
end
