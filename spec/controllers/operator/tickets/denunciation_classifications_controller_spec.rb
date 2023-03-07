require 'rails_helper'

describe Operator::Tickets::DenunciationClassificationsController do

  let!(:denunciation_commission) { create(:executive_organ, acronym: 'COSCO')}
  let!(:ombudsman_coordination) { create(:executive_organ, acronym: 'COUVI')}
  let(:operator_cge_denunciation) { create(:user, :operator_cge_denunciation_tracking) }
  let(:operator_cge) { create(:user, :operator_cge) }

  let(:permitted_params) { %w[
      id
      rede_ouvir
      organ_id
      subnet_id
      unknown_subnet
      description
      sou_type
      denunciation_organ_id
      denunciation_description
      denunciation_date
      denunciation_place
      denunciation_witness
      denunciation_evidence
      denunciation_assurance
    ]
  }

  describe '#update' do
    let(:valid_ticket) { create(:ticket, :denunciation) }
    let(:valid_ticket_attributes) { valid_ticket.attributes }

    let(:valid_ticket_params) { { ticket_id: valid_ticket, denunciation_against_operator: 'true', acronym: 'COSCO' } }

    context 'unauthorized' do
      before { patch(:update, params: valid_ticket_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'forbidden' do
      before { sign_in(operator_cge) && patch(:update, params: valid_ticket_params) }

      it { is_expected.to respond_with(:forbidden) }
    end

    context 'authorized as cge operator denunciation tracking' do
      before { sign_in(operator_cge_denunciation) }

      context 'valid' do
        it 'saves' do
          patch(:update, params: valid_ticket_params)
          valid_ticket.reload

          expect(valid_ticket.denunciation_against_operator).to be_truthy
          is_expected.to redirect_to(operator_ticket_path(valid_ticket, anchor: 'tabs-classification'))
          is_expected.to set_flash.to(I18n.t('operator.tickets.denunciation_classifications.update.done', acronym: 'COSCO'))
        end

        it 'call ticket sharing service' do
          cosco_tickets_attributes = {}
          parent_attributes = valid_ticket.attributes.slice(*permitted_params)
          parent_attributes['id'] = nil
          parent_attributes['organ_id'] = denunciation_commission.id
          cosco_tickets_attributes[0] = parent_attributes

          allow(Ticket::Sharing).to receive(:call)

          patch(:update, params: valid_ticket_params)

          call_params = {
            ticket_id: valid_ticket.id,
            new_tickets_attributes: cosco_tickets_attributes,
            current_user_id: operator_cge_denunciation.id
          }
          expect(Ticket::Sharing).to have_received(:call).with(call_params)
        end
      end

      context 'invalid' do
        it 'does not saves' do
          ticket_complaint = create(:ticket)
          invalid_ticket_params = { ticket_id: ticket_complaint, denunciation_against_operator: 'true' }

          patch(:update, params: invalid_ticket_params)
          ticket_complaint.reload

          expect(ticket_complaint.denunciation_against_operator).to be_falsey
          is_expected.to respond_with(:forbidden)
        end
      end
    end
  end
end
