module StatsEvaluationsHelper

  def stats_evaluations_sorted_organs_data(organs_hash)
    #
    # Ordena primeiro pelos valores dos atributos (DESC) e depos pela chave (ASC)
    #

    # Temos que fica atentos a valores nulos pois o sort explode.

    (organs_hash || {}).sort do |a, b|
      [
        b[1]['average_evaluations'] || 0,
        b[1]['total_user_evaluations'] || 0,
        b[1]['total_answered_tickets'] || 0,
        b[1]['total_tickets'] || 0,
        a[0] || 0
      ] <=> [
        a[1]['average_evaluations'] || 0,
        a[1]['total_user_evaluations'] || 0,
        a[1]['total_answered_tickets'] || 0,
        a[1]['total_tickets'] || 0,
        b[0] || 0
      ]

    end.to_h
  end

  def stats_evaluations_sorted_themes_data(themes_hash)
    (themes_hash || {}).sort.to_h
  end

  def stats_evaluation_last(type)
    Stats::Evaluation.sorted(type).first
  end

  def stats_evaluation_transparency_average_icon(average)
    case average
    when 1..1.8
      'very_dissatisfied_color'
    when 1.8..2.6
      'somewhat_dissatisfied_color'
    when 2.6..3.4
      'neutral_color'
    when 3.4..4.2
      'somewhat_satisfied_color'
    else
      'very_satisfied_color'
    end
  end
end
