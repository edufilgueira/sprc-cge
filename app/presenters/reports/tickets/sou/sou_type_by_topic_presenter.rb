class Reports::Tickets::Sou::SouTypeByTopicPresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper

  COLUMNS = [
    :sou_type,
    :topic,
    :subtopic,
    :organ,
    :count,
    :percentage
  ]

  def initialize(scope, ticket_report)
    @ticket_report = ticket_report
    @hash_scope = scope.left_joins(:organ, classification: [:topic, :subtopic])
      .group('tickets.sou_type', 'topics.name', 'subtopics.name', 'organs.acronym')
      .order('tickets.sou_type', 'topics.name', 'subtopics.name', 'organs.acronym')

    @total = hash_total.values.sum
  end

  def rows
    hash_total.map { |data, count| row(data, count) }
  end

  private

  def row(data, count)
    [ sou_type_str(data[0]), data[1], data[2], data[3], count, percentage(count) ]
  end

  def sou_type_str(key)
    I18n.t "ticket.sou_types.#{key}"
  end
end
