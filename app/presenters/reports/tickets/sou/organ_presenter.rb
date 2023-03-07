class Reports::Tickets::Sou::OrganPresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper
  attr_reader :organs_scope

  def initialize(scope, ticket_report)
    @ticket_report = ticket_report
    @scope = scope
    @organs_scope = scope.group(:organ_id)
  end

  def organ_count(organ)
    total_hash[organ&.id] || 0
  end

  def organ_str(organ)
    organ.title
  end

  def organ_percentage(count)
    number_to_percentage(count.to_f * 100 / total_count, precision: 2) if total_count > 0
  end

  def total_count
    @total_count ||= within_confirmed_at(scope).count + reopened_count(scope)
  end

  def total_hash
    @total_hash ||= within_confirmed_at(organs_scope).count.merge(reopened_count(organs_scope)) { |_, a, b| a + b }
  end
end
