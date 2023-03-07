class Operator::SouEvaluationSamplesController < Operator::TicketsController
  include Operator::SouEvaluationSamples::Breadcrumbs
  include Operator::SouEvaluationSamples::BaseController
  include ActionView::Helpers::SanitizeHelper

  authorize_resource

  PERMITTED_PARAMS = [
    :title,
    :sample_ids,
    :sample_id,
    filtered_params: [
      :organ,:topic,
      :sou_type,
      :answer_type,
      :percentage,
      :start,
      :end
    ]
  ]

  FILTERS_PARAMS = [
    :organ,
    :topic,
    :sou_type,
    :answer_type,
    :percentage
  ]

  #helper methods
  helper_method [
    :sample_ids,
    :filtered_samples_count,
    :total_samples_count
  ]

  def create
    ApplicationRecord.transaction do
      params[:filtered_params] = JSON.parse(params[:filtered_params].gsub('=>',':'))
      params = sou_evaluation_sample_params

      sou_sample = Operator::SouEvaluationSample.new(sou_evaluation_sample_params_hash)
      if sou_sample.save
        create_sample_details
        redirect_to_list_samples_with_success
      end
    end
  end
  
  def filtered_tickets
    @scope = super
  end

  def tickets
    if sou_evaluation_sample_params_present?
      paginated_tickets
    end
  end

  def can_access_index
    if sou_evaluation_sample_params_present?
      authorize! :read, tickets.first || new_resource
    end
  end

  private

  def create_sample_details
    retrieve_tickets_samples_by_ids.each do |ticket| # ticket é o ticket filho
      sample_detail = Operator::SouEvaluationSampleDetail.new(
        sou_evaluation_sample_details_params_hash(ticket)
      )

      if sample_detail.save
        register_ticket_log(ticket)
        register_ticket_log(ticket.parent)
        update_sou_evaluation_in_ticket(ticket)
      end
    end
  end
   
  def sou_evaluation_sample_params
    params.permit(PERMITTED_PARAMS)
  end

  def sou_evaluation_sample_params_present?    
    send('params_present?', *FILTERS_PARAMS)
  end

  def params_present?(*filters_params)
    params.keys.any? {|param| filters_params.include?(param.to_sym)}
  end
end