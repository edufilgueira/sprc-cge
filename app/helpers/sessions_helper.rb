module SessionsHelper

	def url_for_session
		if is_ceara_app?
			ceara_app_sign_in_path
		else
			user_session_path
		end
	end
end