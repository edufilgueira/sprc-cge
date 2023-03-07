class Transparency::PublicTicketsController < TransparencyController
  include Transparency::PublicTickets::Breadcrumbs
  include ::Tickets::BaseController
  include ::PaginatedController
  include ::SortedController


  before_action :sign_out, only: [:show], if: :user_signed_in?

  VALID_TICKET_TYPES = ['sic']

  DEFAULT_TICKET_TYPE = 'sic'

  FILTERED_ENUMS = [
    :sou_type
  ]

  FILTERED_ASSOCIATIONS = [
    :organ,
    { classification: :topic }
  ]

  SOU_SORT_COLUMNS = {
    updated_at: 'tickets.updated_at',
    parent_protocol: 'tickets.parent_protocol',
    sou_type: 'tickets.sou_type',
    internal_status: 'tickets.internal_status',
    deadline: 'tickets.deadline'
  }

  SIC_SORT_COLUMNS = {
    updated_at: 'tickets.updated_at',
    parent_protocol: 'tickets.parent_protocol',
    internal_status: 'tickets.internal_status',
    deadline: 'tickets.deadline'
  }

  helper_method :ticket_like, :ticket_subscription

  # Helper methods

  def tickets
    paginated_tickets
  end

  def ticket
    resource
  end

  def ticket_like
    @ticket_like ||= TicketLike.where(ticket: ticket, user: current_user).first_or_initialize
  end

  def ticket_subscription
    @ticket_subscription ||= create_or_find_ticket_subscription
  end

  def resource_symbol
    :ticket
  end

  def sort_columns
    params[:ticket_type] == 'sic' ? SIC_SORT_COLUMNS : SOU_SORT_COLUMNS
  end

  def readonly?
    true
  end

  def show
    authorize! :view_public_ticket, resource
  end


  private

  def resource_klass
    Ticket
  end

  def paginated_tickets
    paginated(filtered_public_tickets)
  end

  def filtered_public_tickets
    filtered = default_sort_scope

    filtered = filtered.search(params[:search]) if params[:search].present?
    filtered = filtered_tickets_by_organ(filtered)
    filtered = filtered_tickets_by_topic(filtered)
    filtered = filtered_tickets_by_theme(filtered)

    filtered
  end

  def default_sort_scope
    resource_klass.public_tickets.from_type(ticket_type)
  end

  def default_sort_column
    'tickets.updated_at'
  end

  def default_sort_direction
    :desc
  end

  def ticket_type
    default_ticket_type
  end

  def default_ticket_type
    DEFAULT_TICKET_TYPE
  end

  def create_or_find_ticket_subscription
    if current_user.present?
      TicketSubscription.where(ticket: ticket, user: current_user).first_or_initialize
    else
      TicketSubscription.new(ticket: ticket)
    end
  end

end
