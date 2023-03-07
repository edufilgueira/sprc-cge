module Operator::SouEvaluationSamplesHelper

  OTHERS_SAMPLES_FILTERS_PARAMS = [
    :code,
    :status,
    :title
  ]

  def samples_all_status
    Operator::SouEvaluationSample.statuses.keys.map do |status|
      [I18n.t("operator.sou_evaluation_samples.generated_lists.index.filters.status.#{status}"), status]
    end
  end

  def details_sample_count(sample)
    sample.sou_evaluation_sample_details.count
  end

  def percentage_evaluated(sample)
    sample_details = sample.sou_evaluation_sample_details
    (sample_details.with_rated.count.to_f / details_sample_count(sample).to_f) * 100
  end

  def find_user(user_id)
    User.find(user_id)
  end

  def trait_params(parameters)
    parameters[:start] = parameters[:confirmed_at][:start] unless parameters[:confirmed_at].nil?
    parameters[:end] = parameters[:confirmed_at][:end] unless parameters[:confirmed_at].nil?
    parameters = parameters.without('confirmed_at') unless parameters[:confirmed_at].nil?
  end

  def exclude_non_filterable(parameters)
    parameters.without('utf8', 'ticket_type', 'locale', 'controller', 'action', 'sort_column', 'sort_direction', 'page', 'commit')
  end

  def define_submit
    controller_name_sou_evaluation_samples? ? I18n.t('commands.define_sample') : I18n.t('commands.search')
  end

  def samples_filter_params?(params)
    range_created_filtered = has_range_param(params[:created_at])

    other_filters = OTHERS_SAMPLES_FILTERS_PARAMS.any? { |key| params[key].present? }

    range_created_filtered || other_filters
  end

  def remove_sample_open(sample)
    if sample.status == 'open'
      link_to t('commands.remove'), operator_generated_list_path(sample), method: :delete, 'data-confirm': t('commands.remove_confirm'), class: 'btn text-danger btn-link hover-link float-left d-inline-block'
    end
  end

  #privates

  private

  def has_range_param(param)
    param.present? && (param[:start].present? || param[:end].present?)
  end

end
