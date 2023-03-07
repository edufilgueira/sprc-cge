module StatsTicketsHelper

  ORGANS_INDEX_COUNT = 10

  ORGAN_TOPICS_INDEX_COUNT = 5

  USED_INPUTS_INDEX_COUNT = 10

  TOPICS_INDEX_COUNT = 10

  DEPARTMENTS_INDEX_COUNT = 10

  def sort_data_organs_by_total_tickets(organs)
    return {} if organs.nil?

    sort_by_total_tickets(organs)
  end

  def remove_organs_without_tickets(organs)
    organs.except(:total_tickets).delete_if{ |_,v| v[:total_tickets] <= 0 }.to_h
  end

  def stats_summary_serie_keys(summary, ticket_type)
    summary_chart_params(summary).keys.map { |key| [ I18n.t("shared.reports.stats_tickets.summary.#{key}.#{ticket_type}.title") ] }
  end

  def stats_summary_serie_values(summary)
    summary_chart_params(summary).values.map { |data| data[:count] }
  end

  def stats_summary_serie_percentages(summary)
    summary_chart_params(summary).values.map { |data| data[:percentage] }
  end

  def stats_organ_topics_show_serie_keys(topics)
    Topic.where(id: topics.keys).pluck :name
  end

  def stats_organ_topics_show_serie_values(topics)
    topics.values
  end

  def stats_organ_topics_index_serie_data(organ)
    return {} if organ.blank? || organ[:topics].blank?

    total = organ[:topics_count]
    organ_topics_scope = organ_topics_index_scope(organ[:topics])
    topics = organ_topics_scope.map do |key, value|
      {
        count: value,
        title: Topic.with_deleted.find(key).title,
        percentage: (value.to_f * 100 / total).round(2)
      }
    end

    others_count = total - organ_topics_scope.values.sum
    topics <<
      {
        count: others_count,
        title: I18n.t("shared.reports.stats_tickets.index.title_others_topics"),
        percentage: (others_count.to_f * 100 / total).round(2)
      }

    topics
  end

  def last_update(stats_ticket)
    last_update_time = stats_ticket.updated_at || stats_ticket.created_at

    I18n.l(last_update_time, format: :date_time)
  end

  def years_for_select(years_ago)
    current_year = Date.today.year

    ((current_year - years_ago)..(current_year)).to_a.reverse
  end

  def stats_organ_index_serie_keys(organs)
    organs_index_scope(organs).keys.map { |key| [ Organ.find(key).acronym ] } + index_others_key
  end

  def stats_organ_index_serie_values(organs)
    organs_index_scope(organs).values.map { |data| data[:count] } + index_others_values(organs, ORGANS_INDEX_COUNT)
  end

  def stats_organ_index_serie_percentages(organs)
    organs_index_scope(organs).values.map { |data| data[:percentage] } + index_others_percentages(organs, ORGANS_INDEX_COUNT)
  end

  def stats_organ_show_serie_keys(organs)
    organs.keys.map { |key| [ Organ.find(key).acronym ] }
  end

  def stats_organ_show_serie_values(organs)
    organs.values.map { |data| data[:count] }
  end

  def stats_organ_show_serie_percentages(organs)
    organs.values.map { |data| data[:percentage] }
  end

  def stats_used_input_index_serie_keys(used_inputs)
    used_inputs_index_scope(used_inputs).map { |key, _| [I18n.t("ticket.used_inputs.#{key}")] }
  end

  def stats_used_input_index_serie_values(used_inputs)
    used_inputs_index_scope(used_inputs).values.map { |data| data[:count] }
  end

  def stats_used_input_index_serie_percentages(used_inputs)
    used_inputs_index_scope(used_inputs).values.map { |data| data[:percentage] }
  end

  def stats_used_input_show_serie_keys(used_inputs)
    used_inputs.map { |key, _| [I18n.t("ticket.used_inputs.#{key}")] }
  end

  def stats_used_input_show_serie_values(used_inputs)
    used_inputs.values.map { |data| data[:count] }
  end

  def stats_used_input_show_serie_percentages(used_inputs)
    used_inputs.values.map { |data| data[:percentage] }
  end

  def stats_sou_type_serie_keys
    Ticket.sou_types.map { |key, _| [I18n.t("ticket.sou_types.#{key}")] }
  end

  def stats_sou_type_serie_values(sou_types)
    Ticket.sou_types.keys.map do |key|
      sou_type = sou_types.with_indifferent_access[key]
      sou_type.present? ? sou_type[:count] : 0
    end
  end

  def stats_sou_type_serie_percentages(sou_types)
    Ticket.sou_types.keys.map do |key|
      sou_type = sou_types.with_indifferent_access[key]
      sou_type.present? ? sou_type[:percentage] : 0
    end
  end

  def stats_topic_index_serie_keys(topics)
    topics_index_scope(topics).map { |key, _| [ Topic.with_deleted.find(key).title ] } + index_others_key
  end

  def stats_topic_index_serie_values(topics)
    topics_index_scope(topics).values.map { |data| data[:count] } + index_others_values(topics, TOPICS_INDEX_COUNT)
  end

  def stats_topic_index_serie_percentages(topics)
    topics_index_scope(topics).values.map { |data| data[:percentage] } + index_others_percentages(topics, TOPICS_INDEX_COUNT)
  end

  def stats_topic_show_serie_keys(topics)
    topics.map { |key, _| [ Topic.with_deleted.find(key).title ] }
  end

  def stats_topic_show_serie_values(topics)
    topics.values.map { |data| data[:count] }
  end

  def stats_topic_show_serie_percentages(topics)
    topics.values.map { |data| data[:percentage] }
  end

  def stats_department_index_serie_keys(departments)
    departments_index_scope(departments).keys.compact.map { |key| [ Department.find(key).title ] }
  end

  def stats_department_index_serie_values(departments)
    departments_index_scope(departments).values.map { |data| data[:count] }
  end

  def stats_department_index_serie_percentages(departments)
    departments_index_scope(departments).values.map { |data| data[:percentage] }
  end

  def stats_department_show_serie_keys(departments)
    departments.keys.compact.map { |key| [ Department.find(key).title ] }
  end

  def stats_department_show_serie_values(departments)
    departments.values.map { |data| data[:count] }
  end

  def stats_department_show_serie_percentages(departments)
    departments.values.map { |data| data[:percentage] }
  end

  def stats_sectoral_organ_scope_for_select
    [:general, :sectoral].map do |scope|
      [ I18n.t("shared.reports.stats_tickets.index.filters.sectoral.scopes.#{scope}"), scope ]
    end
  end

  def stats_sectoral_subnet_scope_for_select
    [:general, :sectoral].map do |scope|
      [ I18n.t("shared.reports.stats_tickets.index.filters.sectoral.scopes.#{scope}"), scope ]
    end
  end

  private

  def summary_chart_params(summary)
    summary.slice :other_organs, :completed, :partially_completed, :pending
  end

  def organs_index_scope(organs)
    organs.first(ORGANS_INDEX_COUNT).to_h
  end

  def organ_topics_index_scope(topics)
    topics.first(ORGAN_TOPICS_INDEX_COUNT).to_h
  end

  def used_inputs_index_scope(used_inputs)
    used_inputs.first(USED_INPUTS_INDEX_COUNT).to_h
  end

  def topics_index_scope(topics)
    topics.first(TOPICS_INDEX_COUNT).to_h
  end

  def departments_index_scope(departments)
    departments.first(DEPARTMENTS_INDEX_COUNT).to_h
  end

  def topic_percentage(total_tickets, total_tickets_topics)
    (total_tickets * 100).fdiv(total_tickets_topics).floor(2)
  end

  def sort_by_total_tickets(hash)
    hash.sort_by { |_, value| value[:total_tickets] }.reverse.to_h
  end

  def index_others_key
    [I18n.t('messages.others')]
  end

  def index_others_values(resources, resource_count)
    [resources.drop(resource_count).to_h.values.sum { |o| o[:count] }]
  end

  def index_others_percentages(resources, resource_count)
    [resources.drop(resource_count).to_h.values.sum { |o| o[:percentage] }]
  end
end
