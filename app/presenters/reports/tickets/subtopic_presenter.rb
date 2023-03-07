class Reports::Tickets::SubtopicPresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper

  def initialize(scope, ticket_report)
    @ticket_report = ticket_report
    @hash_scope = scope.left_joins(:classification).group('classifications.topic_id', 'classifications.subtopic_id')
    @total = hash_total.values.sum
  end

  def rows
    sorted_hash.map { |data, count| row(data, count) }
  end

  private

  def sorted_hash
    hash_total.sort_by { |_key, value| value }.reverse.to_h
  end

  def row(data, count)
    organ_data = organ_name(data[0])

    ary = [topic_name(data[0]), subtopic_name(data[1]), organ_data, count, percentage(count)]

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

  def subtopic_name(subtopic_id)
    return empty_subtopic unless subtopic_id

    subtopic = Subtopic.find(subtopic_id)
    subtopic.title
  end

  def empty_subtopic
    I18n.t("services.reports.tickets.sou.subtopic.empty")
  end

  def organ_name(topic_id)
    return unless topic_id

    Topic.find(topic_id).organ_acronym
  end
end
