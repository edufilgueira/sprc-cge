class Admin::Integrations::BaseConfigurationsController < AdminController
  helper_method [:configuration]

  # Actions

  def import
    Integration::Importers::Import.call(api_importer_id, configuration.id)
    redirect_to_show_with_success
  end

  # Helper methods

  def configuration
    resource
  end

  # Private

  private

  def resource_klass
    # Conseguimos inferir o resource_klass direto do controller:
    #   admin/integrations/supports/organ/configurations =>
    #   Integration::Supports::Organ::Configuration
    #
    # Basta remover o admin e colocar o integrations no singular que dá o match
    # com o model!
    controller_path.sub('admin/integrations', 'integration').classify.constantize
  end

  def api_importer_id
    # extrai o nome do importador direto da classe:
    # ex: Integration::Supports::Organ::Configuration => supports_organ

    model_name = resource_klass.model_name.param_key

    model_name.scan(/integration_(.*)_configuration/)[0][0].to_sym
  end
end
