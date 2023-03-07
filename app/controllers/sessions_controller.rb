class SessionsController < Devise::SessionsController
  include Sessions::Breadcrumbs
  include ::SingleAuthenticationGuard

  prepend_before_action :check_captcha, only: [:create] #
  before_action :store_user_location!, if: :storable_location?

  helper_method [:title, :description]

  def title
    # O formulário de 'Acessar perfil' (sessions/new) é acessado pelo
    # usuário por 3 formas distintas:
    # 1) via 'Acessar seu perfil'
    # 2) via 'Ouvidoria Digital' estando deslogado
    # 3) via 'Acesso à Informação' estando deslogado
    #
    # Alguns aspectos da página, como o título e breadcrumbs mudam
    # de acordo com as formas.


    # Utilizamos o mesmo título do breadcrumb que já considera que tipo de
    # acesso está sendo feito.
    page_title
  end

  def description
    page_description
  end

  private

  #
  # IMPORTANT a lógica de redirecionamento pós-confirmação - em ConfirmationsController
  # (app/controllers/confirmations_controller.rb) - replica a lógica de redirecionamento
  # pós-autenticação (definida abaixo). Caso algum ajuste seja necessário, avalie se é necessário
  # replicá-lo também na pós-confirmação!'
  #
  def after_sign_in_path_for(resource)
    stored_location_for(resource_name) || redirect_user(resource)
  end

  def after_sign_out_path_for(_resource)
    new_user_session_path
  end

  def after_sign_in_path_for_user
    # determina se o usuário está entrando para
    # 'sou' (ouvidoria) ou para 'sic' (acesso à informação).
    return platform_root_path unless params[:ticket_type].present?
    platform_tickets_path(ticket_type: params[:ticket_type])
  end

  def redirect_user(resource)
    return url_for([:edit, current_user.namespace, current_user]) if resource.password_changed_at.nil?
    return after_sign_in_path_for_user if resource.user?
    url_for([resource.user_type, :root, only_path: true])
  end



  #
  # @see https://github.com/plataformatec/devise/wiki/How-To:-Redirect-back-to-current-page-after-sign-in,-sign-out,-sign-up,-update#storelocation-to-the-rescue
  #
  def storable_location?
    request.get? && is_navigational_format? && !request.xhr?
  end

  def store_user_location!
    store_location_for(resource_name, params[:redirect_to])
  end

  def check_captcha
    unless verify_recaptcha
      self.resource = resource_class.new sign_in_params
      respond_with_navigational(resource) { render :new }
    end
  end
end
