class Operator::GlobalTicketsController < OperatorController
  include ::Operator::GlobalTickets::Breadcrumbs
  include ::PaginatedController
  include ::SortedController
  include ::FilteredController

  # callbacks

  before_action :can_global_tickets_index


  # Consts

  SORT_COLUMNS = [
    'tickets.parent_protocol',
    'tickets.created_at',
    'tickets.ticket_type',
    'tickets.internal_status',
    'tickets.used_input'
  ]

  FILTERED_ENUMS = [
    :ticket_type,
    :used_input,
    :internal_status
  ]

  FILTERED_ASSOCIATIONS = [
    :organ
  ]

  helper_method [:tickets]


  # public

  ## helper methods

  def tickets
    paginated_resources
  end

  # privates

  private

  def filtered_resources
    scope = sorted_resources

    return scope.where(parent_protocol: params[:parent_protocol]) if params[:parent_protocol].present?

    scope = filtered_tickets_by_created_at(scope)
    scope = filtered_tickets_by_organ(scope)

    filtered(resource_klass, scope)
  end

  def default_sort_scope
    resource_klass.parent_tickets
  end

  def resource_klass
    Ticket
  end

  def default_sort_column
    'tickets.parent_protocol'
  end

  def default_sort_direction
    :desc
  end

  def can_global_tickets_index
    authorize! :global_tickets_index, Ticket
  end

  def filtered_tickets_by_organ(scope)
    return scope unless params[:organ].present?
    scope.with_organ(params[:organ])
  end

  def filtered_tickets_by_created_at(scope)
    return scope unless params[:created_at].present?
    scope.where(created_at: start_date_filter..end_date_filter)
  end

  def start_date_filter
    return Date.new(0) unless params[:created_at][:start].present?

    Date.parse(params[:created_at][:start])
  end

  def end_date_filter
    return Float::INFINITY unless params[:created_at][:end].present?

    Date.parse(params[:created_at][:end]).end_of_day
  end

  def filtered_by_associations(_model, resources)
    resources
  end
end
