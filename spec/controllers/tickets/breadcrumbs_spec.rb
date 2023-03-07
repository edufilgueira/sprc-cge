require 'rails_helper'

describe TicketsController do

  context 'new' do
    it 'breadcrumbs' do
      get(:new)

      expected = [
        { title: I18n.t('home.index.breadcrumb_title'), url: root_path },
        { title: I18n.t('sessions.new.ticket_types.sou.title'), url: new_user_session_path(ticket_type: :sou) },
        { title: I18n.t('tickets.new.sou.identified.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'create' do
    before do
      post(:create, params: { ticket: { description: '' }})
    end

    context 'helper methods' do
      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('home.index.breadcrumb_title'), url: root_path },
          { title: I18n.t('sessions.new.ticket_types.sou.title'), url: new_user_session_path(ticket_type: :sou) },
          { title: I18n.t('tickets.create.sou.identified.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end
end
