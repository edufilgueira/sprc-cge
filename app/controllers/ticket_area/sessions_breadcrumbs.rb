# XXX: esse breadcrumb não segue o padrão de nomeação (controller_name/breadcrumb)
# pois o rspec quebra com diversos conflitos de nome:
#
# app/controllers/ticket/sessions_controller.rb:2: warning: toplevel constant Sessions referenced by TicketArea::Sessions
#
# TODO: investigar o problema e repensar organização para minizar os conflitos.
#
# Conflitos podem aparecer quando temos um namespace como mesmo nome de model,
# por exemplo. Como é o caso de 'Ticket'.
#
# Não é possível definir Ticket como modulo, pois já é um classe, e dessas forma
# TicketArea::Algo vira um classe nested e não uma classe em um namespace.
#
module TicketArea::SessionsBreadcrumbs

  protected

  def new_create_breadcrumbs
    [
      [t('home.index.breadcrumb_title'), root_path],
      [t('.title'), '']
    ]
  end
end
