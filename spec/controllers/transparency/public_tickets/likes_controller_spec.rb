require 'rails_helper'

describe Transparency::PublicTickets::LikesController do

  let(:user) { create(:user, :user) }

  let(:ticket) { create(:ticket, :public_ticket) }
  let(:base_params) { { public_ticket_id: ticket.id } }

  let(:valid_params) do
    { public_ticket_id: ticket.id }
  end

  describe '#create' do

    context 'unauthorized' do
      before { post(:create, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      context 'valid' do
        it 'save like' do
          expect do
            post(:create, params: valid_params)

            created = TicketLike.last

            is_expected.to respond_with(:no_content)
            expect(controller.ticket_like).to eq(created)
            expect(controller.ticket_like.ticket).to eq(ticket)
          end.to change(TicketLike, :count).by(1)
        end

        it 'xhr' do
          post(:create, xhr: true, params: valid_params)

          is_expected.to respond_with(:success)
          is_expected.to render_template('transparency/public_tickets/likes/_form')
        end
      end
    end
  end

  describe '#destroy' do
    let!(:ticket_like) { create(:ticket_like, user: user, ticket: ticket) }
    let(:valid_params) do
      {
        public_ticket_id: ticket.id,
        id: ticket_like
      }
    end

    context 'unauthorized' do
      before { delete(:destroy, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'unlike' do
        expect do
          delete(:destroy, params: valid_params)

          is_expected.to respond_with(:no_content)
        end.to change(TicketLike, :count).by(-1)
      end

      it 'xhr' do
        delete(:destroy, xhr: true, params: valid_params)

        is_expected.to respond_with(:success)
        is_expected.to render_template('transparency/public_tickets/likes/_form')
      end
    end
  end
end
