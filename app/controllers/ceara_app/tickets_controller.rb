class CearaApp::TicketsController < TicketsController
	layout 'ceara_app'

	def create
		resource.used_input = :ceara_app
		super
	end
	def redirect_to_show_with_success
    redirect_to ceara_app_ticket_area_ticket_path(resource)
  end

end