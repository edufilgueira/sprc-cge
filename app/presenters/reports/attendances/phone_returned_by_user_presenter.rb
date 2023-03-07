class Reports::Attendances::PhoneReturnedByUserPresenter

  attr_reader :scope

  def initialize(scope)
    @scope = scope
  end

  def count_with_success(user)
    users_with_success_hash[user.id] || 0
  end

  def count_without_success(user)
    users_without_success_hash[user.id] || 0
  end

  def count_by_ticket(user)
    users_by_ticket_hash(user.id) || 0
  end

  private

  def users_with_success_hash
    @users_with_success_hash ||= scope.where(
      attendance_responses: { response_type: AttendanceResponse.response_types['success'] },
      tickets: { answer_type: :phone }
    ).select(:responsible_id).group(:responsible_id).count
  end

  def users_without_success_hash
    @users_without_success_hash ||= scope.where(
      attendance_responses: { response_type: AttendanceResponse.response_types['failure'] },
      tickets: { answer_type: :phone }
    ).select(:responsible_id).group(:responsible_id).count
  end

  def users_by_ticket_hash user_id
    scope.where(tickets: { answer_type: :phone }).select(:ticket_id).where(responsible_id: user_id).group(:ticket_id).count.try(:count)
  end
end
