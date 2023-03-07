module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from CanCan::AccessDenied, with: :error_forbidden!
    rescue_from ActiveRecord::RecordNotFound, with: :error_not_found!
  end


  private

  def error_forbidden!(_err)
    if request.format.json? || request.xhr?
      head :forbidden
    else
      render 'errors/forbidden', status: :forbidden
      # Caso queiramos tratar com redirecionamento, usar:
      # redirect_to forbidden_path
    end
  end

  def error_not_found!(_err)
    if request.format.json? || request.xhr?
      head :not_found
    else
      render 'errors/not_found', status: :not_found
      # Caso queiramos tratar com redirecionamento, usar:
      # redirect_to not_found_path
    end
  end

end
