require 'rails_helper'

describe Operator::Tickets::TransferOrgansController do

  let(:organ) { create(:executive_organ) }
  let(:user) { create(:user, :operator_sectoral, organ: organ) }

  let(:permitted_params) do
    [
      :rede_ouvir,
      :organ_id,
      :subnet_id,
      :unknown_subnet
    ]
  end

  describe "#new" do

    let(:ticket) { create(:ticket, :confirmed, organ: organ, unknown_organ: false) }
    let(:couvi) { create(:executive_organ, :couvi) }
    let(:cosco) { create(:executive_organ, :cosco) }

    context 'unauthorized' do
      before { get(:new, params: { ticket_id: ticket, id: ticket })}

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && couvi && cosco && get(:new, params: { ticket_id: ticket })}

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:new) }
      end

      describe 'helper methods' do
        it 'ticket' do
          expect(controller.ticket).to eq(ticket)
        end
      end
    end
  end

  describe '#create' do

    let(:responsable_organ) { organ }
    let(:transferred_organ) { create(:executive_organ) }
    let(:subnet_from_responsable) { create(:subnet, organ: responsable_organ) }
    let(:ticket) { create(:ticket, :with_classification, organ: responsable_organ, unknown_organ: false, subnet: subnet_from_responsable) }

    let(:valid_params) do
      {
        ticket_id: ticket,
        id: ticket,
        ticket: {
          organ_id: transferred_organ,
          justification: 'Órgão errado'
        }
      }
    end
    let(:invalid_params) do
      {
        ticket_id: ticket,
        id: ticket,
        ticket: {
          organ_id: nil,
          justification: nil
        }
      }
    end

    context 'unauthorized' do
      before { post(:create, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'permited params' do
      
        is_expected.to permit(*permitted_params).
          for(:create, params: valid_params).on(:ticket)
      end

      context 'valid' do
        context 'transfer to organ' do
          it 'saves' do
            post(:create, params: valid_params)

            is_expected.to redirect_to(operator_tickets_path)
            is_expected.to set_flash.to(I18n.t('operator.tickets.transfer_organs.create.done'))
          end

          it 'rede_ouvir' do
            valid_params[:ticket]['organ_id'] = create(:rede_ouvir_organ)

            post(:create, params: valid_params)

            ticket_transfered = controller.ticket
            expect(ticket_transfered.classification.other_organs).to eq(true)
          end

          it 'register ticket log' do
            allow(RegisterTicketLog).to receive(:call)
            data = { subnet_id: ticket.subnet_id }

            post(:create, params: valid_params)


            expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, user, :transfer, { description: valid_params[:ticket][:justification], resource: transferred_organ })
          end

          context 'notify' do
            let(:service) { double }

            before do
              allow(Notifier::Transfer).to receive(:delay) { service }
              allow(service).to receive(:call)

              post(:create, params: valid_params)
            end

            it { expect(service).to have_received(:call).with(ticket.id, user.id) }
          end

          it 'change status' do
            post(:create, params: valid_params)

            expect(ticket.reload.sectoral_attendance?).to be_truthy
          end

          it 'clear classification' do
            post(:create, params: valid_params)

            expect(ticket.reload.classification).to be_blank
            expect(ticket.reload.classified?).to be_falsey
          end

          it 'clear subnet' do
            post(:create, params: valid_params)

            expect(ticket.reload.subnet).to be_blank
          end
        end

        context 'transfer to subnet' do
          let(:transferred_subnet) { create(:subnet, organ: transferred_organ) }
          let(:valid_params) do
            {
              ticket_id: ticket,
              id: ticket,
              ticket: {
                organ_id: transferred_organ,
                subnet_id: transferred_subnet,
                justification: 'Órgão errado'
              }
            }
          end
          it 'saves' do
            post(:create, params: valid_params)

            is_expected.to redirect_to(operator_tickets_path)
            is_expected.to set_flash.to(I18n.t('operator.tickets.transfer_organs.create.done'))
          end

          it 'register ticket log' do
            allow(RegisterTicketLog).to receive(:call)

            post(:create, params: valid_params)


            expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, user, :transfer, { description: 'Órgão errado', resource: transferred_subnet })
          end

          context 'notify' do
            let(:service) { double }

            before do
              allow(Notifier::Transfer).to receive(:delay) { service }
              allow(service).to receive(:call)

              post(:create, params: valid_params)
            end

            it { expect(service).to have_received(:call).with(ticket.id, user.id) }
          end

          it 'change status' do
            post(:create, params: valid_params)

            expect(ticket.reload.subnet_attendance?).to be_truthy
          end

          it 'clear classification' do
            post(:create, params: valid_params)

            expect(ticket.reload.classification).to be_blank
            expect(ticket.reload.classified?).to be_falsey
          end
        end
      end

      context 'invalid' do
        it 'does not saves' do
          expect do
            post(:create, params: invalid_params)

            is_expected.to render_template(:new)
          end.to change(TicketLog, :count).by(0)
        end

        it 'does not saves and recover classification' do
          ticket.update(classified: true)          

          post(:create, params: invalid_params)

          is_expected.to render_template(:new)
          expect(Classification.count).to eq(1)
        end
      end
    end
  end
end
