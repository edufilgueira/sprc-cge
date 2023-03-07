# Platform Tickets RESTful API
#
# 1) INDEX
#    GET /api/v1/platform/tickets?ticket_type=sou&page=1&per_page=1
#    HTTP 200 - [ { ticket }, { ticket }, ... ]
#
# 2) CREATE
#    GET /api/v1/platform/tickets
#    HTTP 201 - created - { ticket }
#
# 3) SHOW
#    GET /api/v1/platform/tickets/{id}
#    HTTP 200 - { ticket }
#
# 4) UPDATE
#    PATCH/PUT /api/v1/platform/tickets/{id}
#    HTTP 200 - { ticket }
#
# 5) DESTROY
#    DELETE /api/v1/platform/tickets/{id}}
#    HTTP 204 - no content
#
# DOCUMENTAÇÃO COMPLETA: https://github.com/caiena/sprc/wiki/API-doc-ticket
class Api::V1::Platform::TicketsController < Api::V1::PlatformController
  include Api::Tickets::BaseController

  before_action :set_ticket_name_and_email, only: :create

  def user_tickets
    current_user.tickets
  end

  def set_ticket_name_and_email
    ticket.name = current_user.name
    ticket.email = current_user.email
  end

  private

  def default_sort_scope
    user_tickets.from_type(ticket_type)
  end
end
