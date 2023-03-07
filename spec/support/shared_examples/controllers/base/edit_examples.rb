# Shared example para action edit de base controllers

shared_examples_for 'controllers/base/edit' do

  let(:resource) { resources.first }

  before { get(:edit, params: valid_params.merge(id: resource.id)) }

  context 'template' do
    render_views

    it 'responds with success and renders templates' do
      expect(response).to be_success
      expect(response).to render_template("#{controller.controller_path}/edit")
      expect(response).to render_template("#{controller.controller_path}/_form")
    end
  end

  context 'assets' do
    # helpers de javascript/stylesheets por asset
    it_behaves_like 'controllers/base/assets'
  end

  it 'resource instance' do
    expect(controller.send(resource_symbol)).to eq(resource)
  end

  private

  def resource_name
    controller.controller_name.singularize
  end

  def resource_symbol
    (controller.try(:send, :resource_symbol) || resource_name).to_sym
  end
end
