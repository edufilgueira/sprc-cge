require 'rails_helper'

describe Operator::TicketDepartmentsController do

  let(:ticket) { create(:ticket, :with_parent) }
  let(:ticket_department) { create(:ticket_department, ticket: ticket) }
  let(:operator_email) { 'test@example.com' }
  let!(:ticket_department_email) { create(:ticket_department_email, :with_positioning, ticket_department: ticket_department, email: operator_email) }

  let(:organ) { ticket.organ }
  let(:user) { create(:user, :operator_sectoral, organ: organ) }

  let(:permitted_params) do
    [
      :deadline_ends_at
    ]
  end

  describe '#edit' do
    context 'unauthorized' do
      before { get(:edit, params: { id: ticket_department }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'forbidden' do
      let(:ticket_department) { create(:ticket_department) }
      before { sign_in(user) && get(:edit, params: { id: ticket_department }) }

      it { is_expected.to respond_with(:forbidden) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:edit, params: { id: ticket_department }) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:edit) }
      end
    end
  end

  describe '#update' do

    let(:valid_department) { ticket_department }
    let(:valid_ticket_attributes) { valid_department.attributes }
    let(:valid_ticket_params) { { id: ticket_department, ticket_department: valid_ticket_attributes } }


    context 'unauthorized' do
      before { patch(:update, params: valid_ticket_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'permits ticket params' do
        should permit(*permitted_params).
          for(:update, params:  valid_ticket_params ).on(:ticket_department)
      end

      context 'valid' do

        it 'update deadline' do
          expected_date = ticket.deadline_ends_at - 1.day
          valid_ticket_params[:ticket_department]['deadline_ends_at'] = expected_date

          expected_flash = I18n.t('operator.ticket_departments.update.done')

          patch(:update, params: valid_ticket_params)

          ticket_department = controller.view_context.ticket_department.reload

          expect(response).to redirect_to(operator_ticket_path(ticket, anchor: 'tabs-areas'))
          expect(controller).to set_flash.to(expected_flash)
          expect(ticket_department.deadline_ends_at).to eq(expected_date)
          expect(ticket_department.deadline).to eq((expected_date - Date.today).to_i)
        end

         it 'call register log' do
          data = {
            deadline_ends_at: ticket.deadline_ends_at,
            department_acronym: ticket_department.department_acronym,
            organ_acronym: ticket.organ_acronym
          }

          allow(RegisterTicketLog).to receive(:call).with(ticket.parent, user, :edit_department_deadline, { resource: ticket_department, data: data })

          patch(:update, params: valid_ticket_params)

          expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, user, :edit_department_deadline, { resource: ticket_department, data: data })
        end

        it 'call notifier' do
          service = double
          allow(Notifier::ExtensionTicketDepartment).to receive(:delay) { service }
          allow(service).to receive(:call).with(ticket_department.id, user.id)

          patch(:update, params: valid_ticket_params)

          expect(service).to have_received(:call).with(ticket_department.id, user.id)
        end
      end
    end
  end

  describe 'GET #poke' do
    let(:valid_params) do
      {
        id: ticket_department.id
      }
    end

    context 'unauthorized' do
      before { get(:poke, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      context 'redirect to ticket#show' do
        let(:expected_flash) { I18n.t("operator.ticket_departments.poke.done", acronym: ticket_department.department_acronym) }
        before { get(:poke, params: valid_params) }

        it { is_expected.to set_flash.to(expected_flash) }
        it { is_expected.to redirect_to(operator_ticket_path(ticket)) }
      end

      it 'call notifier' do
        service = double
        allow(Notifier::TicketDepartment::Poke).to receive(:delay) { service }
        allow(service).to receive(:call).with(ticket_department.id, user.id)

        get(:poke, params: valid_params)

        expect(service).to have_received(:call).with(ticket_department.id, user.id)
      end
    end
  end

  describe 'GET #renew_referral' do
    let(:ticket) { create(:ticket, :with_reopen) }
    let(:ticket_department) { create(:ticket_department, ticket: ticket, answer: :answered) }
    let(:valid_params) {{ id: ticket_department.id }}

    context 'unauthorized' do
      before { get(:renew_referral, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      context 'redirect to ticket#show' do
        let(:expected_flash) { I18n.t("operator.ticket_departments.renew_referral.done", acronym: ticket_department.department_acronym) }
        before { get(:renew_referral, params: valid_params) }

        it { is_expected.to set_flash.to(expected_flash) }
        it { is_expected.to redirect_to(operator_ticket_path(ticket)) }
      end

      it 'change internal_status and ticket_department' do
        get(:renew_referral, params: valid_params)

        ticket.reload
        ticket_department.reload
        ticket_department_email.reload

        expect(ticket.internal_status).to eq('internal_attendance')
        expect(ticket_department.answer).to eq('not_answered')
        expect(ticket_department_email.active).to be_truthy

      end

      context 'notify' do
        let(:service) { double }

        before do
          allow(Notifier::Referral).to receive(:delay) { service }
          allow(service).to receive(:call)
        end

        it 'departments' do
          get(:renew_referral, params: valid_params)

          expect(service).to have_received(:call).with(ticket.id, ticket_department.department_id, user.id)
        end
      end

      context 'send emails for not registred operators' do

        let(:service) { double }

        before do
          allow(Notifier::Referral::AdditionalUser).to receive(:delay) { service }
          allow(service).to receive(:call)

          get(:renew_referral, params: valid_params)
        end

        it { expect(service).to have_received(:call).with(ticket.id, ticket_department_email.id, user.id) }
      end
    end

  end
end
