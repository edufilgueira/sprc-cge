class Reports::Tickets::SubDepartmentPresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper

  COLUMNS = [
    :organ,
    :department,
    :name,
    :count,
    :percentage
  ]

  def initialize(scope, ticket_report)
    @ticket_report = ticket_report
    @hash_scope = scope.leaf_tickets
      .left_joins(:organ, classification: [:department, :sub_department])
      .group('organs.acronym', 'departments.name', 'sub_departments.name')
      .order('organs.acronym', 'departments.name', 'sub_departments.name')

    @total = hash_total.values.sum
  end

  def rows
    hash_total.map { |data, count| row(data, count) }
  end

  private

  def row(data, count)
    [ data[0], data[1], data[2], count, percentage(count) ]
  end

  def percentage(count)
    number_to_percentage(count.to_f * 100 / total, precision: 2)
  end
end
