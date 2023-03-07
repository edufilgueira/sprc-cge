# Operator Tickets RESTful API
#
# 1) INDEX
#    GET /api/v1/operator/tickets?ticket_type=sou&page=1&per_page=1
#    HTTP 200 - [ { ticket }, { ticket }, ... ]
#
# 2) CREATE
#    GET /api/v1/operator/tickets
#    HTTP 201 - created - { ticket }
#
# 3) SHOW
#    GET /api/v1/operator/tickets/{id}
#    HTTP 200 - { ticket }
#
# 4) UPDATE
#    PATCH/PUT /api/v1/operator/tickets/{id}
#    HTTP 200 - { ticket }
#
# 5) DESTROY
#    DELETE /api/v1/operator/tickets/{id}}
#    HTTP 204 - no content
#
# DOCUMENTAÇÃO COMPLETA: https://github.com/caiena/sprc/wiki/API-doc-ticket
class Api::V1::Operator::TicketsController < Api::V1::OperatorController
  include Api::Tickets::BaseController

  PERMITTED_TICKET_USER_METHODS = [ :state_id ]

  PERMITTED_PARAMS = [
    :name,
    :social_name,
    :gender,
    :email,
    :description,
    :sou_type,
    :organ_id,
    :unknown_organ,
    :department_id,
    :unknown_department,
    :status,

    :answer_type,
    :answer_phone,
    :answer_cell_phone,

    :city_id,
    :answer_address_street,
    :answer_address_number,
    :answer_address_zipcode,
    :answer_address_complement,

    attachments_attributes: [
      :id, :document, :_destroy
    ],

    ticket_departments_attributes: [
      :id, :ticket_id, :department_id, :_destroy
    ]
  ]

  # Default actions

  def search
    return object_response([]) unless user_search_params?

    filtered = user_search_tickets
    filtered = filtered.where("LOWER(tickets.name) LIKE LOWER(?)", "%#{param_name}%") if param_name.present?
    filtered = filtered.where("tickets.document = ?", param_document).last if param_document.present?
    filtered = filtered.where("tickets.person_type = ?", param_person_type_enum_value) if param_person_type.present?
    filtered = filtered.order(:name) unless param_document.present?

    object_response(filtered.to_json(methods: PERMITTED_TICKET_USER_METHODS, only: PERMITTED_TICKET_USER_PARAMS))
  end

  # Privates

  private


  def user_tickets
    current_user.operator_accessible_tickets
  end

  def default_sort_scope
    user_tickets.from_type(ticket_type)
  end

  def user_search_tickets
    Ticket.parent_tickets.where.not(confirmed_at: nil).limit(10)
  end

  def user_search_params?
    param_name.present? || param_document.present? || param_person_type.present?
  end

  def param_name
    params[:name]
  end

  def param_document
    params[:document]
  end

  def param_person_type
    params[:person_type]
  end

  def param_person_type_enum_value
    Ticket.person_types["#{param_person_type}"]
  end
end
