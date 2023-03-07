class Operator::Tickets::AttendanceEvaluationsController < OperatorController

  PERMITTED_PARAMS = [
    :clarity,
    :content,
    :wording,
    :kindness,
    :comment,
    :classification,
    :quality,
    :treatment,
    :textual_structure
  ]

  helper_method [:ticket, :attendance_evaluation]

  # Callbacks

  before_action :can_attendance_evaluate_ticket

  # Actions

  def create
    if ticket.present? && resource.save

      register_log(:create_average_internal_evaluation)

      set_success_flash_notice
    else
      set_error_flash_now_alert
    end
  end

  def update
    if ticket.present? && resource.update_attributes(resource_params)
      register_log(:update_average_internal_evaluation)
      set_success_flash_notice
    else
      set_error_flash_now_alert
    end
  end


  # Helpers

  def attendance_evaluation
    resource
  end

  def ticket
    @ticket ||= Ticket.find_by(internal_status: :final_answer, status: :replied, id: params[:ticket_id])
  end

  # Private

  private


  def new_resource
    ticket.build_attendance_evaluation(resource_params) if ticket.present?
  end

  def find_resource
    ticket.present? && ticket.attendance_evaluation
  end

  def render_form
    render partial: 'form', layout: 'layouts/xhr'
  end

  def can_attendance_evaluate_ticket
    authorize! :attendance_evaluate, ticket
  end

  def register_log(action)

    RegisterTicketLog.call(
      ticket.parent,
      current_user,
      action,
      {
        data: {
          average: ticket.attendance_evaluation.average,
          organ_id: ticket.organ.id
        },
        resource_id: resource.id,
        resource_type: controller_name.camelize
      }
    )
  end
end
