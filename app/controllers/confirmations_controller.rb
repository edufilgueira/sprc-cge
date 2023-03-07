class ConfirmationsController < Devise::ConfirmationsController

  def show
    self.resource = resource_class.find_by! confirmation_token: params[:confirmation_token]

    # Usuários que alteraram o e-mail são confirmados ao acessar o link
    if resource.respond_to?(:pending_reconfirmation?) && resource.pending_reconfirmation?
      # XXX garantindo a confirmação de e-mail correta, por conta das validações!
      resource.email_confirmation = resource.unconfirmed_email
      resource.confirm
    end

    # Usuários (do tipo "Usuário") ainda não confirmados (após se registrarem) são confirmados ao
    # acessar o link
    resource.confirm if resource.user? && !resource.confirmed?


    # usuários já confirmados, ou do tipo "Usuário" - que se "registram", ou seja, criam suas
    # contas sozinhos, definindo sua senha - são autenticados e redirecionados para sua "home".
    if resource.confirmed?
      sign_out(resource)
      flash[:notice] = t('devise.confirmations.confirmed')
      redirect_to after_confirmation_path_for(resource_name, resource)
      return
    end

    # senão - para usuários "Operador" ou "Administrador" -, renderize a #show, que terá um form
    # para definição de senha!
  end

  def update
    self.resource = resource_class.find_by! confirmation_token: params[:confirmation_token]
    # forçando a necessidade de se redefinir a senha!
    resource.require_password!
    
    if resource.update(update_resource_params)
      resource.confirm
      sign_out(resource)
      flash[:notice] = t('devise.confirmations.confirmed')
      redirect_to after_confirmation_path_for(resource_name, resource)
    else
      render :show
    end
  end


  private

  #
  # IMPORTANT lógica de redirecionamento pós-confirmação idêntica à lógica de redirecionamento
  # pós-autenticação - replicada de de SessionsController (app/controllers/sessions_controller.rb)
  #

  def after_confirmation_path_for(_resource_name, resource)
    stored_location_for(resource) || redirect_path_for(resource)
  end

  def redirect_path_for(resource)
    return platform_root_path if resource.user?
    return ticket_denunciation_path if resource.operator_denunciation?

    url_for([resource.user_type, :root, only_path: true])
  end

  def ticket_denunciation_path
    operator_tickets_path(ticket_type: :sou, denunciation: true)
  end

  def update_resource_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
