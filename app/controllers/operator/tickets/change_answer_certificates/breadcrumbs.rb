module Operator::Tickets::ChangeAnswerCertificates::Breadcrumbs
  include Operator::Tickets::Breadcrumbs

  protected

  def new_create_breadcrumbs
  end

  def show_edit_update_breadcrumbs
    [
      tickets_index_breadcrumb,
      ticket_show_breadcrumb,
      [t('operator.tickets.change_answer_certificates.edit.title'), '']
    ]
  end

  def index_breadcrumbs
  end

end
