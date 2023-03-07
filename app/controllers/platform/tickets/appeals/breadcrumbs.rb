module Platform::Tickets::Appeals::Breadcrumbs
  include Platform::Tickets::Breadcrumbs

  protected

  def new_create_breadcrumbs
    [
      tickets_index_breadcrumb,
      ticket_show_breadcrumb,
      [t("platform.tickets.appeals.new.title"), '']
    ]
  end

  def index_breadcrumbs
  end
end
