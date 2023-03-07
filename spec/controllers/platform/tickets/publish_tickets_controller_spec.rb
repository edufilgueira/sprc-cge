require 'rails_helper'

describe Platform::Tickets::PublishTicketsController do

  let(:user) { create(:user, :user) }

  let(:ticket) { create(:ticket, :sic, :with_classification, created_by: user) }

  describe '#create'  do
    context 'unauthorized' do
      before { post(:create, params: { ticket_id: ticket }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      before { sign_in(user) }

      context 'unable to publish' do
        let(:ticket) { create(:ticket, :anonymous, created_by: user) }

        before { post(:create, params: { ticket_id: ticket }) }

        it { is_expected.to respond_with(:forbidden) }
      end

      context 'enable to publish' do
        context 'valid' do
          it 'saves' do
            post(:create, params: { ticket_id: ticket.id, public_ticket: true })

            ticket.reload

            expect(response).to redirect_to(platform_ticket_path(ticket))
            expect(ticket.public_ticket?).to be_truthy
          end
        end

        context 'helper methods' do

          before { post(:create, params: { ticket_id: ticket.id, public_ticket: true }) }

          it 'ticket' do
            expect(controller.ticket).to eq(ticket)
          end
        end
      end
    end
  end
end
