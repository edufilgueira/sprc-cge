# Shared example para action new de base controllers

shared_examples_for 'controllers/base/new' do

  before do
    if try(:request_params)
      get(:new, params: request_params)
    else
      get(:new)
    end
  end

  context 'template' do
    render_views

    it 'responds with success and renders templates' do
      expect(response).to be_success
      expect(response).to render_template("#{controller.controller_path}/new")
      expect(response).to render_template("#{controller.controller_path}/_form")
    end
  end

  describe 'helper methods' do
    it 'resource' do
      expect(controller.send(resource_symbol)).to be_new_record
    end
  end

  private

  def resource_name
    controller.controller_name.singularize
  end

  def resource_symbol
    (controller.try(:send, :resource_symbol) || resource_name).to_sym
  end
end
