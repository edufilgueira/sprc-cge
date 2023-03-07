# Shared example para action create de base controllers em admin

shared_examples_for 'controllers/admin/base/create' do
  describe '#create' do
    context 'unauthorized' do
      before { post(:create, params: {}) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/base/create'
    end
  end

  def controller_resource
    controller.send(resource_symbol)
  end

  def resource_symbol
    (controller.try(:send, :resource_symbol) || resource_name).to_sym
  end

  def resource_name
    controller.controller_name.singularize
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
