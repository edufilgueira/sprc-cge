# Shared example para action index com ajax de base controllers

shared_examples_for 'controllers/base/index/xhr' do

  describe '#xhr' do
    render_views

    it 'does not render layout and renders only _index partial' do
      resources

      request

      # Não renderiza layout nem a view padrão, apenas a partial da view (_index)

      expect(response).not_to render_template(layout)
      expect(response).not_to render_template('index')

      expect(response).to render_template(partial: '_index')
    end
  end

  private

  def layout
    controller.controller_path.split('/')[0]
  end

  def request
    if try(:request_params)
      get(:index, xhr: true, params: request_params)
    else
      get(:index, xhr: true)
    end
  end
end
