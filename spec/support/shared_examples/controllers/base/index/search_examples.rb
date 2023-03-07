# Shared example para action index com busca

shared_examples_for 'controllers/base/index/search' do

  describe '#search' do
    # os testes de filtro por busca textual ficam em
    # models/<nome_do_model>/search_spec.rb

    it 'calls search with params[:search]' do
      allow(resource_model).to receive(:search).with('search', any_args).and_call_original
      expect(resource_model).to receive(:search).with('search', any_args).and_call_original

      # Mockamos o controller para não precisar fazer a requisição.
      # get(:index, params: { search: 'search' })
      allow(controller).to receive(:params).and_return(search: 'search')

      # para acionar a busca é preciso acessar o recurso pois é lazy_loaded
      controller.send(resources_symbol)
    end
  end

  private

  def resource_model
    controller.send(:resource_klass)
  end

  def resource_name
    controller.controller_name.singularize
  end

  def resources_symbol
    (controller.try(:send, :resource_symbol) || resource_name).to_s.pluralize.to_sym
  end
end
