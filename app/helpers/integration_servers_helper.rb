module IntegrationServersHelper

  def integration_server_roles_for_select
    sorted_server_roles.map {|server_role| [server_role.name, server_role.id]}
  end

  def integration_server_roles_for_select_with_all_option
    integration_server_roles_for_select.insert(0, [I18n.t('shared.servers.filters.roles'), ' '])
  end

  private

  def sorted_server_roles
    server_roles.order(:name)
  end

  def server_roles
    Integration::Supports::ServerRole.select(:name, :id)
  end
end
