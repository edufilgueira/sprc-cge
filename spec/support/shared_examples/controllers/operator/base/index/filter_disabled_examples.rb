# Shared example para filtro de Mostrar desativados

shared_examples_for 'controllers/operator/base/index/filter_disabled' do
  let(:resource) { create(resource_name) }
  let(:resource_disabled) { create(resource_name, disabled_at: DateTime.now) }

  describe 'filter disabled' do
    it 'default' do
      get(:index)
      expect(resources).to match_array([resource])
    end

    it 'with filter' do
      get(:index, params: { disabled: 'true' })
      expect(resources).to match_array([resource, resource_disabled])
    end
  end

  private

  def resource_name
    controller.send(:resource_klass).name.underscore.split('/').join('_')
  end

  def resources_name
    controller.send(:resource_symbol).to_s.pluralize
  end

  def resources
    controller.send(resources_name)
  end
end
