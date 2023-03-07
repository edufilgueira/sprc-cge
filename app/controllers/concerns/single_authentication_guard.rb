#
# Esse módulo garante que um usário autenticado não possa se
# autenticar novamente em outro model enquanto estiver logado.
#
# Ex.: Um current_user não conseguirá criar uma outra sessão de current_ticket
#
module SingleAuthenticationGuard
  extend ActiveSupport::Concern

  included do
    prepend_before_action :check_already_authenticated!, only: :create
  end

  private

  def check_already_authenticated!
    return unless signed_in?

    set_flash_alert
    redirect_back fallback_location: root_path
  end

  def set_flash_alert
    flash[:alert] = I18n.t("devise.sessions.already_authenticated")
  end
end
