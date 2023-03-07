class Reports::Tickets::Sic::OrganPresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper

  attr_reader :scope, :calc_percentage

  def call_center_organ_demand_count
    @hash_scope = scope.joins(:organ).group("organs.acronym")

    sort_and_limit_hash(hash_with_reopened)
  end

  def call_center_organ_forwarded_count
    @hash_scope = scope.joins(:organ).where.not(attendances: { id: nil }).group("organs.acronym")

    sort_and_limit_hash(hash_with_reopened)
  end

  def organs_demand_count
    @hash_scope  = scope.joins(:organ).where(attendances: { id: nil }).group("organs.acronym")

    sort_and_limit_hash(hash_with_reopened)
  end

  def organ_str(organ)
    organ.title
  end

  def calc_percentage(count, total_count)
    number_to_percentage(count.to_f * 100 / total_count, precision: 2) if total_count > 0
  end
end
