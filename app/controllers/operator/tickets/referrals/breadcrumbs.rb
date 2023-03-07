module Operator::Tickets::Referrals::Breadcrumbs
  include Operator::Tickets::Breadcrumbs

  protected

  def new_create_breadcrumbs
    [
      tickets_index_breadcrumb,
      ticket_show_breadcrumb,
      referral_new_breadcrumb
    ]
  end

  def index_breadcrumbs
  end

  private

  def referral_new_breadcrumb
    [t('operator.tickets.referrals.new.title'), '']
  end

end

