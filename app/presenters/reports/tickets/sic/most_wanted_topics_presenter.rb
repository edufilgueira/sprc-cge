class Reports::Tickets::Sic::MostWantedTopicsPresenter < Reports::Tickets::BasePresenter

  def call_center_topic_demand_count
    @hash_scope = scope.left_joins(classification: :topic).joins(parent: :attendance)
      .group("topics.name")

    sort_and_limit_hash(hash_with_reopened)
  end

  def topics_by_organs_demand_count
    @hash_scope = scope.joins(:organ)
      .left_joins(parent: :attendance).where(attendances: { id: nil })
      .group("organs.acronym")

    organs = sort_and_limit_hash(hash_with_reopened)

    result = []

    organs.each do |acronym, demand|
      @hash_scope = scope.joins(:organ)
        .left_joins(parent: :attendance, classification: :topic)
        .where(attendances: { id: nil }, organs: { acronym: acronym })
        .group("topics.name")

      topics = sort_and_limit_hash(hash_with_reopened)

        result << {
          organ_acronym: acronym,
          organ_demand: demand,
          topics: topics_names(topics)
        }
    end

    result
  end

  def topics_names(topics)
    topics.map do |name, count|
      if name.nil?
        I18n.t('presenters.reports.tickets.sic.most_wanted_topics.no_topic', count: count)
      else
        "#{name}: #{count}"
      end
    end.join("\x0D\x0A")
  end
end
