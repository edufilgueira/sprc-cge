module Operator::Tickets::ChangeDenunciationTypes::Breadcrumbs
  include Operator::Tickets::Breadcrumbs

  protected

  def new_create_breadcrumbs
    [
      tickets_index_breadcrumb,
      ticket_show_breadcrumb,
      change_denunciation_type_new_breadcrumb
    ]
  end

  def index_breadcrumbs
  end

  private

  def change_denunciation_type_new_breadcrumb
    [t('.title'), '']
  end
end
