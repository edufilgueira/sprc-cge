class Reports::Attendances::SummaryPresenter

  attr_reader :scope

  def initialize(scope)
    @scope = scope
  end

  def total_sou_count
    total_sou.count
  end

  def total_sic_count
    total_sic.count
  end

  private

  def total_sou
    scope.where(service_type: [:sou_forward, :no_characteristic])
  end

  def total_sic
    scope.where(service_type: [:sic_forward, :sic_completed])
  end
end
