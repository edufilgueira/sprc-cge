# Shared example para action enable and disable de base controllers

shared_examples_for 'controllers/base/toggle_disabled' do

  let(:resource) { resources.last }

  describe '#toggle_disabled' do
    it '#disable' do
      expected_flash = I18n.t("#{locale_path}.toggle_disabled.disabled")

      sign_in(user) && patch(:toggle_disabled, params: { id: resource })

      expect(controller_resource.reload.disabled?).to be_truthy
      is_expected.to set_flash.to(expected_flash)
      is_expected.to redirect_to(resources_path)
    end

    it '#enable' do
      resource.update_column(:disabled_at, DateTime.now)
      expected_flash = I18n.t("#{locale_path}.toggle_disabled.enabled")

      sign_in(user) && patch(:toggle_disabled, params: { id: resource })

      expect(controller_resource.reload.enabled?).to be_truthy
      is_expected.to set_flash.to(expected_flash)
      is_expected.to redirect_to(resources_path)
    end

    context '#error' do
      before { sign_in(user) }

      it 'enable' do
        resource.disable!
        allow_any_instance_of(controller_resource.class).to receive(:enable!).and_return(false)

        expected_flash = I18n.t("messages.toggle_disabled.error.enable")

        patch(:toggle_disabled, params: { id: resource })

        is_expected.to set_flash.to(expected_flash)
        is_expected.to redirect_to(resources_path)
      end

      it 'disable' do
        resource.enable!
        allow_any_instance_of(controller_resource.class).to receive(:disable!).and_return(false)

        expected_flash = I18n.t("messages.toggle_disabled.error.disable")

        patch(:toggle_disabled, params: { id: resource })

        is_expected.to set_flash.to(expected_flash)
        is_expected.to redirect_to(resources_path)
      end
    end
  end


  private

  def controller_resource
    controller.send(resource_symbol)
  end

  def resource_name
    controller.send(:resource_klass).name.underscore.split('/').join('_')
  end

  def resources_name
    resource_name.pluralize
  end

  def resource_symbol
    controller.try(:send, :resource_symbol) || resource_name.to_sym
  end

  def resources_path
    send("#{namespace}_#{resources_name}_path")
  end

  def namespace
    view_path.split('/').first
  end

  def locale_path
    view_path.gsub('/', '.')
  end

  def view_path
    controller.controller_path
  end
end
