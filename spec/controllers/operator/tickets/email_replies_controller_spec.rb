require 'rails_helper'

describe Operator::Tickets::EmailRepliesController do

  let(:citizen) { create(:user, :user) }
  let(:organ) { create(:executive_organ) }
  let(:ticket) { create(:ticket, :with_parent, organ: organ, created_by: user, internal_status: :final_answer) }
  let(:user) { create(:user, :operator_sectoral, organ: organ) }

  let!(:answer) { create(:answer, :cge_approved, ticket: ticket) }

  let(:permitted_params) do
    [
      :email
    ]
  end

  describe '#edit' do
    context 'unauthorized' do
      before { get(:edit, params: { ticket_id: ticket }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before do
        sign_in(user)
        get(:edit, params: { ticket_id: ticket })
      end

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template('operator/tickets/email_replies/edit') }
        it { is_expected.to render_template('operator/tickets/email_replies/_form') }
      end

      context 'helpers' do
        it 'ticket' do
          expect(controller.ticket).to eq(ticket)
        end
      end
    end
  end

  describe '#update' do
    let(:valid_ticket) { ticket }
    let(:invalid_ticket) do
      ticket.email = ''
      ticket
    end

    let(:valid_attributes) { valid_ticket.attributes }
    let(:valid_params) { { ticket_id: ticket, ticket: valid_attributes } }
    let(:invalid_params) do
      { ticket_id: ticket, ticket: invalid_ticket.attributes }
    end

    context 'unauthorized' do
      before { patch(:update, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      before { sign_in(user) }

      it 'permited params' do
        is_expected.to permit(*permitted_params).
          for(:update, params: { params: valid_params }).on(:ticket)
      end

      context 'invalid' do
        it 'does not update' do
          patch(:update, params: invalid_params)

          expected_flash = I18n.t('operator.tickets.email_replies.update.fail')
          expected_message = I18n.t('operator.tickets.email_replies.update.errors.email')

          expect(controller).to set_flash.to(expected_flash)

          expect(controller.ticket.errors[:email].first).to eq(expected_message)
          expect(response).to render_template('operator/tickets/email_replies/edit')
        end
      end

      context 'valid' do
        it 'update' do
          valid_params[:ticket][:email] = 'new_email@example.com'
          patch(:update, params: valid_params)

          valid_ticket.reload
          expected_flash = I18n.t('operator.tickets.email_replies.update.done', email: valid_ticket.email, protocol: valid_ticket.parent_protocol)

          expect(controller).to set_flash.to(expected_flash)
          expect(valid_ticket.email).to eq('new_email@example.com')
          expect(valid_ticket.parent.email).to eq('new_email@example.com')
          expect(response).to redirect_to(operator_ticket_path(ticket))
        end

        it 'send email to user' do
          service = double
          allow(Ticket::EmailReply).to receive(:delay) { service }
          allow(service).to receive(:call)

          patch(:update, params: valid_params)

          valid_ticket.reload

          expect(service).to have_received(:call).with(ticket.id)
        end

        context 'redirect path when comes from' do
          let(:ticket_call_center) { create(:ticket, :replied, :call_center) }
          let(:user) { create(:user, :operator_call_center) }

          context 'call_center_ticket' do
            let(:referrer_path) { operator_call_center_ticket_path(id: ticket_call_center)}

            before do
              allow_any_instance_of(ActionController::TestRequest).to receive(:referrer) do
                "#{referrer_path}&previous_url=call_center_tickets"
              end
              valid_params[:ticket_id] = ticket_call_center
              patch(:update, params: valid_params)
            end

            it { expect(response).to redirect_to(referrer_path) }
          end

          context 'ticket' do
            let(:referrer_path) { operator_ticket_path(ticket)}

            before do
              allow_any_instance_of(ActionController::TestRequest).to receive(:referrer) do
                referrer_path
              end

              patch(:update, params: valid_params)
            end

            it { expect(response).to redirect_to(referrer_path) }
          end
        end
      end
    end
  end
end
