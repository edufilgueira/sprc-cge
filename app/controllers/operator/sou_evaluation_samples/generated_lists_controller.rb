class Operator::SouEvaluationSamples::GeneratedListsController < OperatorController
  include Operator::SouEvaluationSamples::GeneratedLists::Breadcrumbs
  include ActionView::Helpers::SanitizeHelper
  include ::Tickets::BaseController

  authorize_resource

  #helper methods
  helper_method [
    :ticket_type,
    :title,
    :list_samplings,
    :filtered_samples_count,
    :total_samples_count
  ]

  SEARCH_EXPRESSION = ''

  SORT_COLUMNS = [
    :code,
    :title,
    :status,
    nil,
    nil,
    :created_at
  ]

  FILTERED_COLUMNS = [
    :code,
    :status,
    :created_at
  ]

  FILTERED_DATE_RANGE = [:created_at]

  PERMITTED_PARAMS = [
    :code,
    :status,
    created_at: [:start, :end]
  ]

  def list_samplings
    list_samplings ||= paginated_resources
  end

  def show
    resource
  end
  
  def index
  end
  
  def set_success_flash_notice
    flash[:notice] = t('.done') if action_name == 'destroy'
  end

  def title
    t('.title')
  end

  def ticket_type
  end

  def resource_klass
    Operator::SouEvaluationSample
  end

  def default_sort_scope
    resource_klass
  end

  def filtered_samples_count
    filtered_resources.count
  end

  def total_samples_count
    paginated_resources.count
  end

  def filtered_resources
    filtered = sorted_resources
    filtered = filtered_tickets_finalized(filtered)
    filtered = filtered_tickets_by_confirmed_at(filtered)
    filtered = filtered_sou_evaluation_samples_by_code(filtered)
    filtered = filtered_sou_evaluation_samples_by_status(filtered)
    filtered = filtered_sou_evaluation_samples_by_title(filtered)
    filtered
  end

  def filtered_sou_evaluation_samples_by_code(scope)
    return scope unless params[:code].present?

    scope.where(code: params[:code])
  end

  def filtered_sou_evaluation_samples_by_status(scope)
    return scope unless params[:status].present?

    scope.where(status: params[:status])
  end

  # sobrescrevendo devido o pai usar o confirmad_at
  def filtered_tickets_by_confirmed_at(scope)
    return scope if params[:created_at].nil?

    return scope unless (params[:created_at][:start].present? && params[:created_at][:end].present?)

    scope.where(created_at: start_date_filter..end_date_filter)
  end

  # sobrescrevendo devido o pai usar o confirmad_at
  def start_date_filter
    return resource_klass.first_created_date.to_date unless params[:created_at][:start].present?

    Date.parse(params[:created_at][:start])
  end

  # sobrescrevendo devido o pai usar o confirmad_at
  def end_date_filter
    return Date.today.end_of_day unless params[:created_at][:end].present?

    Date.parse(params[:created_at][:end]).end_of_day
  end

  # sobrescrevendo pois implementação é desnecessaria e causa bug
  def filtered_tickets_finalized(filtered)
    filtered
  end

  def filtered_sou_evaluation_samples_by_title(scope)
    return scope unless params[:title].present?

    scope.where("title ILIKE '%#{params[:title]}%'")
  end

  def resource
    @resource ||= Operator::SouEvaluationSample.find(params[:id])
  end

end
