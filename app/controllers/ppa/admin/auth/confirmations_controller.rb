class PPA::Admin::Auth::ConfirmationsController < Devise::ConfirmationsController
  layout 'ppa/admin'

  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # override
  def show
    self.resource = resource_class.find_by! confirmation_token: params[:confirmation_token]

    # Usuários que alteraram o e-mail são confirmados ao acessar o link
    if resource.respond_to?(:pending_reconfirmation?) && resource.pending_reconfirmation?
      resource.confirm
    end

    # usuários já confirmados são autenticados e redirecionados para sua "home".
    if resource.confirmed?
      sign_out(resource)
      flash[:notice] = t('devise.confirmations.confirmed')
      redirect_to after_confirmation_path_for(resource_name, resource)
      return
    end

    # senão, renderize a #show, que terá um form para definição de senha!
  end

  # XXX nova action, que permita a definição de senha no primeiro acesso
  # override
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


  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end

  private

  def update_resource_params
    params.require(:ppa_admin).permit(:password, :password_confirmation)
  end

end
