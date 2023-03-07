module Operator::Tickets::Invalidations::Breadcrumbs
  include Operator::Tickets::Breadcrumbs

  protected

  def new_create_breadcrumbs
    [
      tickets_index_breadcrumb,
      ticket_show_breadcrumb,
      invalidation_new_breadcrumb
    ]
  end

  def index_breadcrumbs
  end

  private

  def invalidation_new_breadcrumb
    [t('operator.tickets.invalidations.new.title'), '']
  end

end

