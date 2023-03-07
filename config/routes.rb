Rails.application.routes.draw do
  # As rotas estão separadas por arquivos em config/routes
  #
  # admin: rotas do admin
  # api: rotas de api
  # application: rotas da área externa
  # ckeditor: rotas relacionadas ao ckeditor
  # devise: rotas relacionadas ao devise
  # operator: rotas relacionadas ao operador
  # platform: rotas relacionadas a área de usuários com conta
  # ppa: rotas relacionadas ao PPA
  # sidekiq: rotas relacionadas ao sidekiq
  # ticket_area: rotas relacionadas a área de usuários do tipo protocolo
  # transparency: rotas relacionadas ao portal da transparência
  # about: rotas relacionadas a informações da plataforma
  # ceara_app: rotas do Ceará APP

  # XXX: a linha de baixo quebra o Refile em OpenData::DataItem fazendo com que
  # os links de anexos redirecionem para 404.
  # get '*path', :to => 'application#page_not_found'
end
