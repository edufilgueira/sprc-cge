module Operator::Tickets::ChangeSouTypes::Breadcrumbs
  include Operator::Tickets::Breadcrumbs

  protected

  def new_create_breadcrumbs
    [
      tickets_index_breadcrumb,
      ticket_show_breadcrumb,
      change_sou_type_new_breadcrumb
    ]
  end

  def index_breadcrumbs
  end

  private

  def change_sou_type_new_breadcrumb
    [t('.title'), '']
  end
end
