require 'rails_helper'

describe Operator::Tickets::ChangeDenunciationOrgansController do

  let(:user) { create(:user, :operator_cge_denunciation_tracking) }
  let(:permitted_params) { [:denunciation_organ_id] }

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
    let(:organ) { create(:executive_organ) }
    let(:sou_ticket) do
      ticket = create(:ticket, :confirmed, :denunciation, classified: true)
      ticket.denunciation_organ_id = organ.id
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
        post(:create, params: valid_ticket_params)

        expected_flash = I18n.t("operator.tickets.change_denunciation_organs.create.done")

        sou_ticket.reload

        expect(sou_ticket.denunciation_organ_id).to eq(organ.id)
        expect(response).to redirect_to(operator_ticket_path(sou_ticket))
        expect(controller).to set_flash.to(expected_flash)
      end

      it 'invalid' do
        allow_any_instance_of(Ticket).to receive(:save).and_return(false)
        post(:create, params: valid_ticket_params)

        expected_flash = I18n.t("operator.tickets.change_denunciation_organs.create.fail")

        sou_ticket.reload

        expect(response).to render_template('operator/tickets/change_denunciation_organs/new')
        expect(controller).to set_flash.now.to(expected_flash)
        expect(sou_ticket.denunciation_organ_id).to_not eq(organ.id)
      end
    end
  end
end
