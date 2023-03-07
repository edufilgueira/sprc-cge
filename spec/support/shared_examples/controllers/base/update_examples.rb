# Shared example para action update de base controllers

shared_examples_for 'controllers/base/update' do

  let(:resource) { resources.first }

  describe 'helper methods' do
    it 'resource' do
      patch(:update, params: valid_params.merge(id: resource.id))

      expect(controller_resource).to eq(resource)
    end
  end

  it 'permitted_params' do
    is_expected.to permit(*permitted_params).
        for(:update, params: valid_params.merge(id: resource.id)).on(resource_symbol)
  end

  context 'valid' do
    it 'saves' do
      last_updated_at = Date.today - 4.days
      resource.update_attribute(:updated_at, last_updated_at)

      patch(:update, params: valid_params.merge(id: resource.id))

      updated = resource
      updated.reload

      expect(response).to redirect_to(controller.send(:resource_show_path))
      expect(updated.updated_at).not_to eq(last_updated_at)

      expect(controller).to set_flash.to(I18n.t("#{locale_path}.update.done") % { title: updated.title })
    end
  end

  context 'invalid' do
    render_views

    it 'does not save' do
      resource

      allow_any_instance_of(resource_model).to receive(:valid?).and_return(false)

      patch(:update, params: valid_params.merge(id: resource.id))

      expected_flash = I18n.t("#{locale_path}.update.error", { title: controller_resource.title })

      expect(response).to render_template("#{view_path}/edit")
      expect(controller).to set_flash.now.to(expected_flash)
    end
  end

  private

  def controller_resource
    controller.send(resource_symbol)
  end

  def resource_name
    controller.controller_name.singularize
  end

  def resource_symbol
    controller.try(:send, :resource_symbol) || resource_name.to_sym
  end

  def locale_path
    view_path.gsub('/', '.')
  end

  def view_path
    controller.controller_path
  end

  def resource_model
    controller.send(:resource_klass)
  end
end
