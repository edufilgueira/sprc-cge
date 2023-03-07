module AttendancesHelper

  # Ordem definida pela CGE
  SERVICE_TYPES_ORDER = [
    :sou_forward,
    :sic_forward,
    :sic_completed,
    :sou_search,
    :sic_search,
    :no_communication,
    :no_characteristic,
    :prank_call,
    :noise,
    :immediate_hang_up,
    :hang_up,
    :technical_problems,
    :missing_data,
    :incorrect_click,
    :transferred_call
  ]

  OTHER_FILTER_PARAMS = [
    :search,
    :parent_protocol,
    :created_by_id,
    :ticket_type,
    :sou_type,
    :internal_status,
    :organ_id,
    :answer_type,
    :deadline,
    :service_type,
    :call_center_responsible_id
  ]


  def attendance_service_types_for_select
    service_types_keys.map do |type|
      [Attendance.human_attribute_name("service_type.#{type}"), type]
    end
  end

  def attendance_created_by_for_select
    attendance_call_center_users.pluck(:name, :id)
  end

  def attendance_scope_params(service_types, user)
    scope = {service_type: service_types}

    scope.merge!(created_by_id: user.id) if user.call_center?

    scope
  end

  def attendance_waiting_feedback_count(user)
    user.call_center_tickets.waiting_feedback.count
  end

  def attendance_filter_params?(params)
    range_filtered = (params[:created_at].present?) &&
      (params[:created_at][:start].present? || params[:created_at][:end].present?)

    filtered = OTHER_FILTER_PARAMS.any? {|key| params[key].present? }

    filtered || range_filtered
  end

  private

  def service_types_keys
    SERVICE_TYPES_ORDER
  end

  def attendance_call_center_users
    User.call_center.enabled.sorted
  end

end
