# Shared example para action destroy de base controllers

shared_examples_for 'controllers/base/destroy' do

  let(:resource) { resources.first }

  it 'destroys' do
    resource

    expect do
      request

      expect(controller_resource).to eq(resource)

      expected_flash = I18n.t("#{locale_path}.destroy.done",
        title: resource.title)

      expect(response).to redirect_to(controller.send(:resource_index_path))
      expect(controller).to set_flash.to(expected_flash)
    end.to change(resource_model, :count).by(-1)
  end

  it 'does not destroys' do
    allow_any_instance_of(resource_model).to receive(:destroy).and_return(false)
    request

    expected_flash = I18n.t("#{locale_path}.destroy.error", title: resource.title)

    expect(response).to redirect_to(controller.send(:resource_index_path))
    expect(controller).to set_flash.to(expected_flash)
  end

  private

  def controller_resource
    controller.send(resource_symbol)
  end

  def resource_name
    controller.controller_name.singularize
  end

  def resource_symbol
    (controller.try(:send, :resource_symbol) || resource_name).to_sym
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

  def request
    if try(:request_params)
      delete(:destroy, params: request_params.merge(id: resource))
    else
      delete(:destroy, params: { id: resource })
    end
  end
end
