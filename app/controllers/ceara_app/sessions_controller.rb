class CearaApp::SessionsController < SessionsController
	layout 'ceara_app'

	def after_sign_in_path_for_user
    # determina se o usuário está entrando para
    # 'sou' (ouvidoria) ou para 'sic' (acesso à informação).
    return ceara_app_platform_root_path unless params[:ticket_type].present?
    ceara_app_platform_tickets_path(ticket_type: params[:ticket_type])
  end
end