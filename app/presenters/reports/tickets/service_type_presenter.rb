class Reports::Tickets::ServiceTypePresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper

  COLUMNS = [
    :organ,
    :name,
    :count,
    :percentage
  ]

  def initialize(scope, ticket_report)
    @ticket_report = ticket_report
    @hash_scope = scope.left_joins(:organ, classification: :service_type)
      .group('organs.acronym', 'service_types.name')
      .order('organs.acronym', 'service_types.name')

    @total = hash_total.values.sum
  end

  def rows
    hash_total.map { |data, count| row(data, count) }
  end

  private

  def row(data, count)
    organ_data = include_organ? ? [data[0]] : []

    organ_data + [ data[1], count, percentage(count) ]
  end
end
