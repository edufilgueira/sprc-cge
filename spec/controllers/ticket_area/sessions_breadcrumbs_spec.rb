require 'rails_helper'

# XXX: sem esse require o rspec está se perdendo no carregamento de constantes
# com mesmo nome.
#
# sprc/spec/controllers/ticket_area/sessions_breadcrumbs_spec.rb:5: warning: toplevel constant SessionsController referenced by TicketArea::SessionsController
#
# TODO: investigar o problema e repensar organização para minizar os conflitos.
#
# Conflitos podem aparecer quando temos um namespace como mesmo nome de model,
# por exemplo. Como é o caso de 'Ticket'.
#
# Não é possível definir Ticket como modulo, pois já é um classe, e dessas forma
# TicketArea::Algo vira um classe nested e não uma classe em um namespace.

require 'ticket_area/sessions_controller'

describe TicketArea::SessionsController do

  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  context 'new' do
    before { get(:new) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('home.index.breadcrumb_title'), url: root_path },
        { title: I18n.t('ticket_area.sessions.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'create' do
    before do
      post(:create, params: { user: { name: '' }})
    end

    context 'helper methods' do
      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('home.index.breadcrumb_title'), url: root_path },
          { title: I18n.t('ticket_area.sessions.create.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end
end
