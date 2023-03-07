class Transparency::HomeController < TransparencyController
  include Transparency::Home::Breadcrumbs

  helper_method :pages, :daes, :cache_key

  # Helper methods

  def pages
    Page.sorted_parents
  end

  def daes
    Integration::Constructions::Dae.where.not(latitude: nil, longitude: nil)
    .order(:data_fim_previsto)
  end

  def cache_key
    # TODO: 
    # metodo está aqui para atender necessidade de view (render) 
    # app/views/shared/transparency/server_salaries/index/_chart.html.haml
    # render usad para exibir grafico de servidores
    # porém não implementa cache para a home de transparency
    # e implementa cache para index de servidores
  end
end
