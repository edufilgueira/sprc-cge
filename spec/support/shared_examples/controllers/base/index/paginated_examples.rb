# Shared example para action index com paginação

shared_examples_for 'controllers/base/index/paginated' do

  describe '#index' do

    before do
      # Mockamos o controller para não precisar fazer a requisição.
      # get(:index, params: { page: 2 })

      if try(:request_params)
        allow(controller).to receive(:params).and_return(request_params.merge({page: '2'}))
      else
        allow(controller).to receive(:params).and_return(page: '2')
      end
    end

    context 'pagination' do
      it 'calls kaminari methods' do
        allow(resource_model).to receive(:page).and_call_original
        expect(resource_model).to receive(:page).and_call_original

        # Não precisamos fazer a requisição pois estamos testando apenas
        # um helper_method que irá paginar a collection do controller.
        # get(:index, params: {})

        # para poder chamar o page que estamos testando
        controller.send(resources_symbol)
      end

      it 'limits page' do
        # Temos que garantir que, caso a página passada seja maior que o total
        # de páginas, seja usada a última página.
        #
        # Isso pode acontencer em casos como:
        #
        # 1) abrir um index que tenha mais de 1 página e ir para a última;
        # 2) usar algum filtro que limite os resultados apresentados, fazendo
        # com que a nova quantidade de página seja menor que a última anterior;
        # 3) sem limitar a página, nada é exibido na index pois o offset passado
        # é maior que a quantidade de registros.

        allow(controller).to receive(:total_pages).and_return(1)
        allow(controller).to receive(:per_page).and_return(1)

        # para poder chamar o page que estamos testando
        controller.send(resources_symbol)

        expect(controller.params[:page]).to eq(1)
      end
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
