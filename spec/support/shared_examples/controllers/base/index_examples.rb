# Shared example para action index de base controllers

shared_examples_for 'controllers/base/index' do

  describe '#index' do
    before do
      if respond_to?(:request_params)
        get(:index, params: request_params)
      else
        get(:index)
      end
    end

    context 'template' do
      render_views

      it 'responds with success and renders templates' do
        expect(response).to be_success
        expect(response).to render_template("#{controller.controller_path}/index")
      end
    end

    describe 'helper methods' do
      it 'resources' do
        resources

        expect(controller.send(resources_symbol)).to match_array(resources)
      end
    end
  end

  private

  def resource_name
    controller.controller_name.singularize
  end

  def resources_symbol
    (controller.try(:send, :resource_symbol) || resource_name).to_s.pluralize.to_sym
  end
end
