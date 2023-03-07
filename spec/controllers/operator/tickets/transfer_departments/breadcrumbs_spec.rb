
require 'rails_helper'

describe Operator::Tickets::TransferDepartmentsController do

  let(:user) { create(:user, :operator) }

  before { sign_in(user) }

  describe 'edit' do

    context 'sou tickets' do
      let(:ticket) { create(:ticket, ticket_type: :sou) }
      let(:ticket_department) { create(:ticket_department, ticket: ticket) }

      before { get(:edit, params: { ticket_id: ticket, id: ticket_department }) && ticket.reload }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('operator.tickets.transfer_departments.edit.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    context 'sic tickets' do
      let(:ticket) { create(:ticket, ticket_type: :sic) }
      let(:ticket_department) { create(:ticket_department, ticket: ticket) }

      before { get(:edit, params: { ticket_id: ticket, id: ticket_department }) && ticket.reload }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sic.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sic) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sic) },
          { title: I18n.t('operator.tickets.transfer_departments.edit.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  describe 'create' do
    context 'sou tickets' do
      let(:ticket) { create(:ticket, ticket_type: :sou) }
      let(:ticket_department) { create(:ticket_department, ticket: ticket) }
      let(:invalid_ticket_department) do
        ticket_department.department = nil
        ticket_department
      end
      let(:invalid_ticket_department_params) { { ticket_id: ticket, id: ticket_department, ticket_department: invalid_ticket_department.attributes } }

      before { ticket.reload }
      before { get(:edit, params: invalid_ticket_department_params) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sou.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sou) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sou) },
          { title: I18n.t('operator.tickets.transfer_departments.edit.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    context 'sic tickets' do
      let(:ticket) { create(:ticket, ticket_type: :sic) }
      let(:ticket_department) { create(:ticket_department, ticket: ticket) }
      let(:invalid_ticket_department) do
        ticket_department.department = nil
        ticket_department
      end
      let(:invalid_ticket_department_params) { { ticket_id: ticket, id: ticket_department, ticket_department: invalid_ticket_department.attributes } }

      before { ticket.reload }
      before { get(:edit, params: invalid_ticket_department_params) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.tickets.index.sic.breadcrumb_title'), url: operator_tickets_path(ticket_type: :sic) },
          { title: ticket.title, url: operator_ticket_path(ticket, ticket_type: :sic) },
          { title: I18n.t('operator.tickets.transfer_departments.edit.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end
end
