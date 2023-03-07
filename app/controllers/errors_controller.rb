#
# Páginas dinâmicas de erro, renderizada pelo ActionDispatch.
#
# Veja mais em https://mattbrictson.com/dynamic-rails-error-pages
# https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/middleware/public_exceptions.rb
#
class ErrorsController < ApplicationController
  # override
  # Flexibilizando falha de CSRF - com null session - para conseguir tratar
  # erros de CSRF com a action #unprocessable_entity
  protect_from_forgery with: :null_session

  #
  # 403: Para exceções de CanCan/permissões
  #
  def forbidden
    respond_to_error :forbidden, message: t('.title')
  end

  #
  # 404: Para rota não existente; RecordNotFound; ...
  #
  def not_found
    respond_to_error :not_found, message: t('.title')
  end

  # 500: Para erros não esperados ("RuntimeError")
  def internal_server_error
    respond_to_error :internal_server_error, message: t('.title')
  end


  private

  def respond_to_error(status, message: nil)
    if request.xhr? || request.format.json?
      render status: status, json: { message: message }
    else
      # Precisa de template próprio? Senão, poderíamos fazer:
      # `render_default_template status: status`
      render action_name, status: status
    end
  end

end
