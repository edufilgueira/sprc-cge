class Reports::Attendances::AttendancesByUserPresenter

  attr_reader :scope

  def initialize(scope)
    @scope = scope
  end

  def count(user)
    users_hash[user.id] || 0
  end

  private

  def users_hash
    @users_hash ||= scope.select(:created_by_id).group(:created_by_id).count
  end
end
