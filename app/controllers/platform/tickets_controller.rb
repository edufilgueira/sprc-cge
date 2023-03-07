class Platform::TicketsController < PlatformController
  include Platform::Tickets::Breadcrumbs
  include Tickets::BaseController

  SOU_SORT_COLUMNS = [
    'tickets.created_at',
    'tickets.updated_at',
    'tickets.parent_protocol',
    'tickets.sou_type',
    'tickets.internal_status',
    'tickets.deadline'
  ]

  SIC_SORT_COLUMNS = [
    'tickets.created_at',
    'tickets.updated_at',
    'tickets.parent_protocol',
    'tickets.internal_status',
    'tickets.deadline'
  ]

  load_resource except: :create
  authorize_resource

  helper_method [:justification]

  # Actions
  def create
    ticket.ticket_type = ticket_type
    ticket.name = current_user.name
    ticket.social_name = current_user.social_name
    ticket.email = current_user.email
    ticket.document = current_user.document unless ticket.document.present?
    ticket.document_type = current_user.document_type unless ticket.document_type.present?
    ticket.answer_facebook = current_user.facebook_profile_link unless ticket.answer_facebook.present?

    super do
      update_created_ticket_status_and_child
    end

  end

  # Helpers

  def tickets
    paginated_tickets
  end

  def sort_columns
    params[:ticket_type] == 'sic' ? SIC_SORT_COLUMNS : SOU_SORT_COLUMNS
  end

  private

  def user_tickets
    current_user.tickets.parent_tickets
  end

  def resource_save
    human? && resource.save
  end

  def human?
    verify_recaptcha(model: resource, attribute: :recaptcha)
  end

  def justification
  end

  def default_sort_scope
    user_tickets.from_type(ticket_type)
  end

  def default_sort_column
    'tickets.updated_at'
  end

  def default_sort_direction
    :desc
  end

  def filtered_tickets_finalized(scope)
    scope
  end

  #
  # Sobrescrevendo o filtro 'internal_status' de tickets/base_controller
  #
  def filtered_tickets_by_internal_status(scope)
    param = params[:status_for_citizen]

    return scope unless param.present?

    param.to_sym == :inactive ? scope.inactive : scope.active
  end
end
