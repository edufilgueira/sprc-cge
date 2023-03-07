module TopicsHelper

  def topics_transfer_targets_for_select(topic)
    Topic.where.not(id: topic.id).map do |target|
      [ target.title, target.id ]
    end
  end

  def topic_by_id_for_select(topic_id)
    topic = Topic.find_by_id(topic_id)

    return [] if topic.nil?

    [[topic.title, topic.id]].to_h
  end

  def citizen_topics_for_select
    sorted_topics.map {|topic| [topic_title(topic), topic.organ_id]}
  end

  def sorted_topics
    Topic.without_no_characteristic.enabled.sorted
  end

  def topic_title(topic)
    acronym = "[#{topic.organ.acronym}] - " unless topic.organ.nil?

    "#{acronym}#{topic.name}"
  end

  def topic_organ_id(topic)
    topic.organ_id
  end

end
