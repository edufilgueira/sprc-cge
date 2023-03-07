class Reports::Tickets::BudgetProgramPresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper

  COLUMNS = [
    :organ,
    :name,
    :count,
    :percentage
  ]

  def initialize(scope, ticket_report)
    @ticket_report = ticket_report
    @hash_scope = scope.left_joins(:organ, classification: :budget_program)
      .group('organs.acronym', 'budget_programs.name')
      .order('organs.acronym', 'budget_programs.name')

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
