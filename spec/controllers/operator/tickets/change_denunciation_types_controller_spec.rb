require 'rails_helper'

describe Operator::Tickets::ChangeDenunciationTypesController do

  let(:user) { create(:user, :operator_cge_denunciation_tracking) }
  let(:permitted_params) { [:denunciation_type] }

  describe "#new" do
    let(:sou_ticket) { create(:ticket, :confirmed, :denunciation, classified: true) }

    context 'unauthorized' do
      it 'without login' do
        get(:new, params: { ticket_id: sou_ticket })
        is_expected.to redirect_to(new_user_session_path)
      end

      it 'forbidden' do
        operator_cge = create(:user, :operator_cge)
        sign_in(operator_cge) && get(:new, params: { ticket_id: sou_ticket })

        is_expected.to respond_with(:forbidden)
      end
    end

    context 'authorized' do
      before { sign_in(user) && get(:new, params: { ticket_id: sou_ticket }) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:new) }
      end
    end
  end

  describe '#create' do
    let(:sou_ticket) do
      ticket = create(:ticket, :confirmed, :denunciation, classified: true)
      ticket.denunciation_type = Ticket.denunciation_types.keys.first
      ticket
    end

    let(:valid_ticket_params) { { ticket_id: sou_ticket, ticket: sou_ticket.attributes } }

    context 'unauthorized' do
      it 'without login' do
        post(:create, params: valid_ticket_params)

        is_expected.to redirect_to(new_user_session_path)
      end

      it 'forbidden' do
        operator_cge = create(:user, :operator_cge)
        sign_in(operator_cge) && post(:create, params: valid_ticket_params)

        is_expected.to respond_with(:forbidden)
      end
    end

    context 'valid' do
      before { sign_in(user) }

      it 'permits ticket params' do
        should permit(*permitted_params).
          for(:create, params: valid_ticket_params ).on(:ticket)
      end

      it 'saves' do
        expect do
          post(:create, params: valid_ticket_params)

          expected_flash = I18n.t("operator.tickets.change_denunciation_types.create.done")

          sou_ticket.reload

          expect(sou_ticket.denunciation_type).to eq('in_favor_of_the_state')
          expect(response).to redirect_to(operator_ticket_path(sou_ticket))
          expect(controller).to set_flash.to(expected_flash)
        end.to change(TicketLog, :count).by(1)
      end

      it 'invalid' do
        allow_any_instance_of(Ticket).to receive(:save).and_return(false)
        post(:create, params: valid_ticket_params)

        expected_flash = I18n.t("operator.tickets.change_denunciation_types.create.fail")

        sou_ticket.reload

        expect(response).to render_template('operator/tickets/change_denunciation_types/new')
        expect(controller).to set_flash.now.to(expected_flash)

        expect(sou_ticket.denunciation_type).to_not eq('in_favor_of_the_state')
      end
    end
  end
end
