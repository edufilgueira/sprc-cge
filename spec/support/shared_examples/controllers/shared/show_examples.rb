# Shared example para action show de shared controllers

shared_examples_for 'controllers/shared/show' do

  before do
    if try(:request_params)
      get(:show, params: request_params.merge(id: resource.id))
    else
      get(:show, params: { id: resource.id })
    end
  end

  let(:resource) do
    resources.first
  end

  describe '#show' do
    context 'template' do
      render_views

      it 'responds with success and renders templates' do
        expect(response).to be_success
        expect(response).to render_template("#{controller.send(:controller_base_view_path)}/show")
      end
    end

    context 'assets' do
      # helpers de javascript/stylesheets por asset
      it_behaves_like 'controllers/shared/assets'
    end

    it 'resource instance' do
      expect(controller.send(resource_symbol)).to eq(resource)
    end
  end

  def resources_name
    controller.controller_name
  end

  def resource_name
    resources_name.singularize
  end

  def resource_symbol
    controller.try(:send, :resource_symbol) || resource_name.to_sym
  end

  def resource_model
    resource.class
  end
end
