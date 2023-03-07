class Reports::Attendances::ServiceTypePresenter

  attr_reader :scope

  def initialize(scope)
    @scope = scope
  end

  def count(service_type)
    scope.where(service_type: service_type).count
  end
end
