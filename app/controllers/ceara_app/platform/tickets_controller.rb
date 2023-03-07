class CearaApp::Platform::TicketsController < Platform::TicketsController
	layout 'ceara_app'

	def create
		resource.used_input = :ceara_app
		super
	end
end