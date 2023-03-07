require 'rails_helper'

describe Operator::Tickets::TransferDepartmentsController do

  let(:ticket_department) { create(:ticket_department) }
  let(:user) { create(:user, :operator_internal, department: ticket_department.department, organ: ticket_department.department.organ) }

  let(:permitted_params) do
    [
      :id,
      :department_id,
      :justification
    ]
  end

  describe "#edit" do
    let(:ticket) { ticket_department.ticket }

    context 'unauthorized' do
      before { get(:edit, params: { ticket_id: ticket, id: ticket_department }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:edit, params: { ticket_id: ticket, id: ticket_department }) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:edit) }
      end

      describe 'helper methods' do
        it 'ticket' do
          expect(controller.ticket).to eq(ticket)
        end

        it 'ticket_department' do
          expect(controller.ticket_department).to eq(ticket_department)
        end
      end
    end
  end

  describe '#update' do
    let(:ticket_department) { create(:ticket_department) }
    let(:ticket) { ticket_department.ticket }
    let(:current_department) { ticket_department.department }
    let(:transferred_department) { create(:department) }
    let(:valid_params) do
      {
        ticket_id: ticket,
        id: ticket_department,

        ticket_department: {
          department_id: transferred_department,
          justification: 'Area interna errada'
        }
      }
    end
    let(:invalid_params) do
      {
        ticket_id: ticket,
        id: ticket_department,

        ticket_department: {
          department_id: nil,
          justification: nil
        }
      }
    end

    context 'unauthorized' do
      before { patch(:update, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'permited params' do
        should permit(*permitted_params).
          for(:update, params: valid_params ).on(:ticket_department)
      end

      context 'valid' do
        it 'saves' do
          expect do
            patch(:update, params: valid_params)

            is_expected.to redirect_to(operator_tickets_path)
            is_expected.to set_flash.to(I18n.t('operator.tickets.transfer_departments.update.done'))
          end.to change(TicketLog, :count).by(1)
        end

        it 'register ticket log' do
          allow(RegisterTicketLog).to receive(:call)

          patch(:update, params: valid_params)

          expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, user, :transfer, { description: 'Area interna errada', resource: transferred_department })
        end

        context 'notify' do
          let(:service) { double }

          before do
            allow(Notifier::Transfer).to receive(:delay) { service }
            allow(service).to receive(:call)

            patch(:update, params: valid_params)
          end

          it { expect(service).to have_received(:call).with(ticket.id, user.id, ticket_department.id) }
        end
      end

      context 'invalid' do
        it 'does not saves' do
          expect do
            patch(:update, params: invalid_params)

            is_expected.to render_template(:edit)
          end.to change(TicketLog, :count).by(0)
        end
      end
    end
  end
end
