require 'rails_helper'

describe Operator::Tickets::ChangeAnswerCertificatesController do

  let(:user) { create(:user, :operator) }

  before { sign_in(user) }

  describe 'edit' do
    let(:answer) { create(:answer, ticket: ticket) }

    before { get(:edit, params: { ticket_id: ticket, id: answer }) && ticket.reload }

    context 'sou tickets' do
      let(:ticket) { create(:ticket, ticket_type: :sou) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('operator.tickets.change_answer_certificates.edit.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    context 'sic tickets' do
      let(:ticket) { create(:ticket, ticket_type: :sic) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sic.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sic) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sic) },
          { title: I18n.t('operator.tickets.change_answer_certificates.edit.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  describe 'update' do
    let(:answer) { create(:answer, ticket: ticket) }
    let(:invalid_answer_attributes) do
      {
        certificate: nil
      }
    end
    let(:answer_params) { { ticket_id: ticket, id: answer, answer: invalid_answer_attributes } }

    context 'sou tickets' do
      let(:ticket) { create(:ticket, created_by: user, ticket_type: :sou) }

      before { ticket.reload && patch(:update, params: answer_params) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('operator.tickets.change_answer_certificates.edit.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    context 'sic tickets' do
      let(:ticket) { create(:ticket, created_by: user, ticket_type: :sic) }

      before { ticket.reload && patch(:update, params: answer_params) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sic.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sic) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sic) },
          { title: I18n.t('operator.tickets.change_answer_certificates.edit.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end
end
