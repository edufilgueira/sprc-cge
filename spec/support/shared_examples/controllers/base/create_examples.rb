# Shared example para action create de base controllers

shared_examples_for 'controllers/base/create' do

  describe 'helper methods' do
    it 'resource' do
      expect(controller_resource).to be_new_record
    end
  end

  it 'permitted_params' do
    is_expected.to permit(*permitted_params).
      for(:create, params: valid_params).on(resource_symbol)
  end

  context 'valid' do
    it 'saves' do
      expect do
        post(:create, params: valid_params)

        resource = controller_resource

        # facilita o tdd para quando o model é mais elaborado e com relações
        # obrigatórias
        expect(resource.errors.full_messages).to eq([])

        created = resource_model.last

        expected_flash = I18n.t("#{locale_path}.create.done", { title: created.title })

        expect(response).to redirect_to(controller.send(:resource_show_path))
        expect(controller).to set_flash.to(expected_flash)

      end.to change(resource_model, :count).by(1)
    end

    it 'redirects based on from param' do
      expect do
        post(:create, params: valid_params.merge(from: :index))

        resource = controller_resource

        expect(response).to redirect_to(controller.send(:resource_index_path))

      end.to change(resource_model, :count).by(1)
    end
  end

  context 'invalid' do
    render_views

    it 'does not save' do
      allow_any_instance_of(resource_model).to receive(:valid?).and_return(false)

      expect do
        post(:create, params: valid_params)

        expected_flash = I18n.t("#{locale_path}.create.error", { title: controller_resource.title })

        expect(response).to render_template("#{view_path}/new")
        expect(controller).to set_flash.now.to(expected_flash)

      end.to change(resource_model, :count).by(0)
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
end
