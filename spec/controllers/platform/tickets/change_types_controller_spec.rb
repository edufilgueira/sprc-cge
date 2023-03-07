require 'rails_helper'

describe Platform::Tickets::ChangeTypesController do

  let(:sou_ticket) { create(:ticket, :confirmed, :with_parent, classified: true) }
  let(:sic_ticket) { create(:ticket, :confirmed, ticket_type: :sic, classified: true) }
  let(:user) { create(:user, :user) }

  let(:permitted_params) do
    [
      :sou_type,
      :denunciation_organ_id,
      :denunciation_description,
      :denunciation_date ,
      :denunciation_place ,
      :denunciation_witness,
      :denunciation_evidence,
      :denunciation_assurance
    ]
  end

  describe "#new" do
    context 'unauthorized' do
      before { get(:new, params: { ticket_id: 1 }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:new, params: { ticket_id: sou_ticket }) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(200) }
        it { is_expected.to render_template(:new) }
      end

    end
  end

  describe '#create' do
    context 'unauthorized' do
      before do
        post(:create, params: { ticket_id: 1 })
      end

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      let(:organ) { create(:executive_organ) }

      let(:sic_ticket_params) do
        {
          ticket_id: sic_ticket.id,

          ticket: {
            sou_type: :denunciation,
            denunciation_organ_id: organ.id,
            denunciation_description: '123',
            denunciation_date: 'last week',
            denunciation_place: 'street 4',
            denunciation_witness: 'Joao',
            denunciation_evidence: 'yes',
            denunciation_assurance: 'rumor'
          }
        }
      end

      before { sign_in(user) }

      context 'valid' do
        it 'change to sic' do
          post(:create, params: { ticket_id: sou_ticket })
          sou_ticket.reload

          expect(sou_ticket).to be_sic
        end

        it 'change to sic without document' do
          sou_ticket.update_column(:document, '')

          post(:create, params: { ticket_id: sou_ticket })
          sou_ticket.reload

          # não deve ser possível mudar o tipo se o docimento for vazio
          expect(sou_ticket).to be_sou
        end

        it 'change to sou' do
          post(:create, params: sic_ticket_params)
          sic_ticket.reload

          expect(sic_ticket).to be_sou
          expect(sic_ticket.denunciation_description).to eq('123')
        end

        context 'save ticket log change' do
          it 'sou' do
            from = sou_ticket.sou_type.to_s

            allow(RegisterTicketLog).to receive(:call)
            post(:create, params: { ticket_id: sou_ticket })

            expected_attributes = {
              data: {
                responsible_as_author: user.as_author,
                from: from,
                to: 'sic'
              }
            }

            expect(RegisterTicketLog).to have_received(:call).with(sou_ticket.parent, user, :change_ticket_type, expected_attributes)
          end

          it 'sic' do
            to = sic_ticket_params[:ticket][:sou_type]

            allow(RegisterTicketLog).to receive(:call)
            post(:create, params: sic_ticket_params)

            expected_attributes = {
              data: {
                responsible_as_author: user.as_author,
                from: 'sic',
                to: to.to_s
              }
            }

            expect(RegisterTicketLog).to have_received(:call).with(sic_ticket, user, :change_ticket_type, expected_attributes)
          end
        end

        it 'notify' do
          service = double

          allow(Notifier::ChangeTicketType).to receive(:delay) { service }
          allow(service).to receive(:call)

          post(:create, params: { ticket_id: sou_ticket })

          expect(service).to have_received(:call).with(sou_ticket.parent.id)
        end

        it 'ticket_original_type' do
          sic_ticket_params[:ticket][:sou_type] = nil

          post(:create, params: sic_ticket_params)

          expect(controller.ticket_original_type).to eq('sic')
        end
      end

      context 'invalid' do
        it 'does not saves' do
          allow(ChangeTicketType).to receive(:call).and_return(false)

          post(:create, params: { ticket_id: sou_ticket })

          expect(controller).to render_template(:new)
          expect(controller).to set_flash.now.to(I18n.t('shared.tickets.change_types.create.fail'))
        end
      end
    end
  end
end
