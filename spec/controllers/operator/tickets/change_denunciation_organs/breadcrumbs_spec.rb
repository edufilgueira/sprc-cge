require 'rails_helper'

describe Operator::Tickets::ChangeDenunciationOrgansController do

  let(:user) { create(:user, :operator_cge) }

  before { sign_in(user) }

  describe 'new' do

    context 'sou tickets' do
      let(:ticket) { create(:ticket, :denunciation, created_by: user) }

      before { get(:new, params: { ticket_id: ticket }) && ticket.reload }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('operator.tickets.change_denunciation_organs.new.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end
end
