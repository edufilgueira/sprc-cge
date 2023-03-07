class Reports::Attendances::WhatsappReturnedByUserPresenter

  attr_reader :scope

  def initialize(scope)
    @scope = scope
  end

  def count(user)
    users_hash[user.id] || 0
  end

  private

  def users_hash
    @users_hash ||= scope.where(
      tickets: { answer_type: :whatsapp }
    ).select(:responsible_id).group(:responsible_id).count
  end
end
