module Sessions::Breadcrumbs

  protected

  def new_create_breadcrumbs
    [
      [t('home.index.breadcrumb_title'), root_path],
      [page_title, '']
    ]
  end

  def page_title
    ticket_type = params[:ticket_type]

    if ticket_type.present? && valid_ticket_types_params.include?(ticket_type)
      t(".ticket_types.#{ticket_type}.title")
    else
      t('.title')
    end
  end

  def page_description
    ticket_type = params[:ticket_type]

    if ticket_type.present? && valid_ticket_types_params.include?(ticket_type)
      t(".ticket_types.#{ticket_type}.description")
    end
  end

  def valid_ticket_types_params
    Ticket.ticket_types.keys + ['denunciation']
  end
end
