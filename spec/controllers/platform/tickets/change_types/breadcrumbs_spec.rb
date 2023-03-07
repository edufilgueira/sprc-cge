require 'rails_helper'

describe Platform::Tickets::ChangeTypesController do

  let(:user) { create(:user, :user) }

  before { sign_in(user) }

  describe 'new' do

    context 'sou tickets' do
      let(:ticket) { create(:ticket, created_by: user, ticket_type: :sou) }

      before { get(:new, params: { ticket_id: ticket }) && ticket.reload }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('platform.tickets.index.sou.breadcrumb_title'), url: platform_tickets_path(ticket_type: :sou) },
          { title: ticket.title, url: platform_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('shared.tickets.change_types.new.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    context 'sic tickets' do
      let(:ticket) { create(:ticket, created_by: user, ticket_type: :sic) }

      before { get(:new, params: { ticket_id: ticket }) && ticket.reload }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('platform.tickets.index.sic.breadcrumb_title'), url: platform_tickets_path(ticket_type: :sic) },
          { title: ticket.title, url: platform_ticket_path(ticket, ticket_type: :sic) },
          { title: I18n.t('shared.tickets.change_types.new.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  describe 'create' do

    let(:params) do
      { ticket_id: ticket.id,
        ticket: {
          ticket_departments_attributes: {
            '1' => { description: 'Descrição' }
          }
        }
      }
    end

    context 'sou tickets' do
      let(:ticket) { create(:ticket, :confirmed, created_by: user, ticket_type: :sou) }
      before { post(:create, params: params) && ticket.reload }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('platform.tickets.index.sic.breadcrumb_title'), url: platform_tickets_path(ticket_type: :sic) },
          { title: ticket.title, url: platform_ticket_path(ticket, ticket_type: :sic) },
          { title: I18n.t('shared.tickets.change_types.new.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    context 'sic tickets' do
      let(:ticket) { create(:ticket, :confirmed, created_by: user, ticket_type: :sic) }

      before { post(:create, params: params) && ticket.reload }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('platform.tickets.index.sou.breadcrumb_title'), url: platform_tickets_path(ticket_type: :sou) },
          { title: ticket.title, url: platform_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('shared.tickets.change_types.new.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

  end
end
