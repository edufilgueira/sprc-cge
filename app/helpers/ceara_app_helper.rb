module CearaAppHelper
  def is_ceara_app?
    controller.class.parent.to_s.include? 'CearaApp'
  end

  def url_to_platform_ticket
  	if is_ceara_app?
  		[:ceara_app, :platform, ticket]
  	else
  		[:platform, ticket]
  	end
  end

  def url_to_new_platform_ticket
    if is_ceara_app?
      new_ceara_app_platform_ticket_path(ticket_type: ticket_type)
    else
      new_platform_ticket_path(ticket_type: ticket_type)
    end
  end

  def link_to_platform_ticket_show_path(ticket)
    if is_ceara_app?
      ceara_app_platform_ticket_path(ticket)
    else
      platform_ticket_path(ticket)
    end
  end
end