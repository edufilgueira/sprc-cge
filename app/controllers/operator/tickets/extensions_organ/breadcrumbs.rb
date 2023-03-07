module Operator::Tickets::ExtensionsOrgan::Breadcrumbs
  include Operator::Tickets::Breadcrumbs

  protected

  def new_create_breadcrumbs
    [
      tickets_index_breadcrumb,
      ticket_show_breadcrumb,
      extension_organ_new_breadcrumb
    ]
  end

  def index_breadcrumbs
  end

  private

  def extension_organ_new_breadcrumb
    [t('operator.tickets.extensions_organ.new.title'), '']
  end

end

