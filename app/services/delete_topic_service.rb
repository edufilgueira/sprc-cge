class DeleteTopicService

  def self.call(topic, target_topic_id, target_subtopics_ids)
    new.call(topic, target_topic_id, target_subtopics_ids)
  end

  def call(topic, target_topic_id, target_subtopics_ids)
    @topic = topic
    @target_topic_id = target_topic_id
    @target_subtopics_ids = target_subtopics_ids

    (without_classification_associated? || transfer_topic?) && @topic.destroy
  end

  private

  def without_classification_associated?
    Classification.find_by(topic: @topic).blank?
  end

  def transfer_topic?
    return false unless @target_topic_id.present? && (empty_subtopics? || transfer_subtopics?)
    Classification.where(topic: @topic).update_all(topic_id: @target_topic_id)

    true
  end

  def transfer_subtopics?
    return false unless @target_subtopics_ids.present? && valid_target_subtopics?

    @target_subtopics_ids.each do |current, target|
      Classification.where(subtopic: current).update_all(subtopic_id: target)
    end

    true
  end

  def valid_target_subtopics?
    valid_target_topics_keys && valid_target_topics_values
  end

  def target_topics_keys
    @target_subtopics_ids.keys.map(&:to_i)
  end

  def target_topics_values
    @target_subtopics_ids.values
  end

  def valid_target_topics_keys
    target_topics_keys == @topic.subtopics.pluck(:id)
  end

  def valid_target_topics_values
    target_topics_values.reject(&:blank?).count == target_topics_keys.count
  end

  def empty_subtopics?
    @topic.subtopics.empty?
  end
end
