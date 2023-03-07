module ::Tickets::BaseBreadcrumbs

  protected

  def index_breadcrumbs
    [
      home_breadcrumb,
      [t("#{namespace}.tickets.index.#{ticket_type}.breadcrumb_title"), '']
    ]
  end

  def new_create_breadcrumbs
    [
      home_breadcrumb,
      [t("#{namespace}.tickets.index.#{ticket_type}.breadcrumb_title"), url_for([namespace, :tickets, ticket_type: ticket_type, only_path: true])],
      [t("#{namespace}.tickets.new.#{ticket_type}.title"), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      home_breadcrumb,
      tickets_index_breadcrumb,
      [ticket_show_title, '']
    ]
  end

  private

  def home_breadcrumb
      [t('home.index.title'), root_path]
  end

  def ticket_show_title
    if ticket.in_progress? && action_name == 'show'
      t("#{namespace}.tickets.show.in_progress.#{ticket.ticket_type}.title")
    else
      ticket.title
    end
  end

  def tickets_index_breadcrumb
    [t("#{namespace}.tickets.index.#{ticket.ticket_type}.breadcrumb_title"), url_for([namespace, :tickets, ticket_type: ticket.ticket_type, only_path: true])]
  end

  def ticket_show_breadcrumb
    [ticket.title, url_for([namespace, ticket, ticket_type: ticket.ticket_type, only_path: true])]
  end
end
