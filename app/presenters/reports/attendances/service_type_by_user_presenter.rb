class Reports::Attendances::ServiceTypeByUserPresenter

  attr_reader :scope

  def initialize(scope)
    @scope = scope
  end

  def row(user)
    [user.name] + row_by_service_types(user)
  end

  private

  def row_by_service_types(user)
    service_type_keys.map { |service_type| count(user, service_type) }
  end

  def count(user, service_type)
    users_by_service_type_hash[[user.id, service_type]] || 0
  end

  def users_by_service_type_hash
    @users_by_service_type_hash ||= scope.group(:created_by_id, :service_type).count
  end

  def service_type_keys
    Attendance.service_types.keys
  end
end
