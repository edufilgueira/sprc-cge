class Reports::Tickets::TopicPresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper

  def initialize(scope, ticket_report)
    @ticket_report = ticket_report
    @hash_scope = scope.left_joins(:classification).group('classifications.topic_id')
    @total = hash_total.values.sum
  end

  def rows
    sorted_hash.map { |topic_id, count| row(topic_id, count) }
  end

  private

  def sorted_hash
    hash_total.sort_by { |_key, value| value }.reverse.to_h
  end

  def row(topic_id, count)
    organ_data = organ_name(topic_id)

    ary = [topic_name(topic_id), organ_data, count, percentage(count)]

    ary -= [organ_data] unless include_organ?

    ary

  end

  def topic_name(topic_id)
    return empty_topic unless topic_id

    topic = Topic.find(topic_id)
    topic.name
  end

  def empty_topic
    I18n.t("services.reports.tickets.sou.topic.empty")
  end

  def organ_name(topic_id)
    return unless topic_id

    Topic.find(topic_id).organ_acronym
  end
end
