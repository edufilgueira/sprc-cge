require 'rails_helper'

describe Operator::Tickets::AttendanceResponsesController do
  let(:user) { create(:user, :operator_call_center) }

  let(:ticket) { create(:ticket) }

  let(:permitted_params) do
    [:description]
  end

  let(:description) { 'updated description' }

  let(:valid_params) do
    {
      ticket_id: ticket.id,
      attendance_response: {
        description: description
      }
    }
  end

  let(:invalid_params) do
    {
      ticket_id: ticket.id,
      attendance_response: {
        description: ''
      }
    }
  end

  describe "#new" do
    context 'unauthorized' do
      before { get(:new, params: { ticket_id: ticket }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:new, params: { ticket_id: ticket }) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:new) }
      end

      describe 'helper methods' do
        it 'attendance_response' do
          expect(controller.attendance_response).to be_new_record
        end
      end
    end
  end

  describe 'failure' do
    context 'unauthorized' do
      before { post(:failure, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      render_views

      context 'invalid' do
        it 'does not saves' do
          expect do
            post(:failure, params: invalid_params)

            expected_flash = I18n.t('operator.tickets.attendance_responses.failure.error')

            is_expected.to render_template(:new)
            is_expected.to set_flash.now[:alert].to(expected_flash)
          end.to change(AttendanceResponse, :count).by(0)
        end
      end

      context 'valid' do
        it 'permitted params' do
          should permit(*permitted_params).
            for(:failure, verb: :post, params: valid_params).on(:attendance_response)
        end

        it 'saves' do
          expect do
            post(:failure, params: valid_params)

            expected_flash = I18n.t('operator.tickets.attendance_responses.failure.done')

            is_expected.to redirect_to(operator_call_center_ticket_path(ticket))
            is_expected.to set_flash.to(expected_flash)

            expect(controller.attendance_response).to be_failure
            expect(controller.ticket.call_center_feedback_at).to be_nil
          end.to change(AttendanceResponse, :count).by(1)
        end


        context 'register ticket log' do
          before { allow(RegisterTicketLog).to receive(:call) }

          it 'after save' do
            post(:failure, params: valid_params)
            expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :attendance_response, { resource: controller.attendance_response })
          end
        end
      end
    end
  end

  describe 'success' do
    context 'unauthorized' do
      before { post(:success, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      render_views

      context 'invalid' do
        it 'does not saves' do
          expect do
            post(:success, params: invalid_params)

            expected_flash = I18n.t('operator.tickets.attendance_responses.success.error')

            is_expected.to render_template(:new)
            is_expected.to set_flash.now[:alert].to(expected_flash)
          end.to change(AttendanceResponse, :count).by(0)
        end
      end

      context 'valid' do
        let(:now) { 0.days.ago }

        before { allow(DateTime).to receive(:now) { now } }

        it 'permitted params' do
          should permit(*permitted_params).
            for(:success, verb: :post, params: valid_params).on(:attendance_response)
        end

        it 'saves' do
          expect do
            post(:success, params: valid_params)

            expected_flash = I18n.t('operator.tickets.attendance_responses.success.done')

            is_expected.to redirect_to(operator_call_center_ticket_path(ticket))
            is_expected.to set_flash.to(expected_flash)

            expect(controller.attendance_response).to be_success
            expect(controller.ticket.call_center_feedback_at).to eq(now)
            expect(controller.ticket.with_feedback?).to eq(true)
          end.to change(AttendanceResponse, :count).by(1)
        end
      end
    end
  end

end
