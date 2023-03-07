# RESTful API pública de Cargos (Integration::Supports::ServerRole)
#
# 1) INDEX
#    GET /api/v1/integration/support/server_roles
#    HTTP 200 - [ { role }, { role }, ... ]
#
class Api::V1::Integration::Supports::ServerRolesController < Api::V1::ApplicationController
  include FilteredController

  FILTERED_ASSOCIATIONS = [
    { integration_supports_organs: :codigo_folha_pagamento }
  ]

  # Actions

  def index
    object_response(server_roles)
  end

  # Privates

  private

  def server_roles
    filtered_server_roles
  end

  def filtered_server_roles
    filtered(::Integration::Supports::ServerRole, sorted_server_roles)
  end

  def sorted_server_roles
    includes = { organ_server_roles: :organ }

    resources.includes(includes).references(includes).sorted
  end

  def resources
    @resources ||= Integration::Supports::ServerRole.all
  end
end
