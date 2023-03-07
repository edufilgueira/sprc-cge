require 'rails_helper'

describe Ticket::DeleteSharing do

  let(:ticket) { create(:ticket, :with_parent, :in_sectoral_attendance)}
  let(:ticket_parent) { ticket.parent }
  let(:service) { Ticket::DeleteSharing.new(ticket.id, user.id) }

  describe 'delete sharing' do
    context 'Operator CGE' do
      let(:user) { create(:user, :operator_cge)}

      it 'self.call' do
        service = double
        allow(Ticket::DeleteSharing).to receive(:new).with(ticket.id, user.id) { service }
        allow(service).to receive(:call)

        Ticket::DeleteSharing.call(ticket.id, user.id)

        expect(Ticket::DeleteSharing).to have_received(:new).with(ticket.id, user.id)
        expect(service).to have_received(:call)
      end

      it 'initialization' do
        expect(service.ticket_parent).to be_an_instance_of(Ticket)
        expect(service.current_user).to be_an_instance_of(User)
      end

      it 'delete last child' do
        ticket
        expect do
          service.call

          ticket_parent.reload

          expect(ticket_parent.internal_status).to eq("waiting_referral")
        end.to change(Ticket, :count).by(-1)
      end

      it 'delete one child' do
        ticket_organ = create(:ticket, :with_organ, :in_sectoral_attendance, parent: ticket_parent)
        ticket_parent.tickets << ticket_organ
        ticket_parent.save
        ticket
        expect do
          service.call

          ticket_parent.reload

          expect(ticket_parent.internal_status).to eq("sectoral_attendance")
        end.to change(Ticket, :count).by(-1)
      end

      it 'register ticket_log' do
        allow(RegisterTicketLog).to receive(:call)

        data_expected = {
          protocol: ticket.parent_protocol,
          organ: ticket.organ_acronym
        }

        service.call

        expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :delete_share, { data: data_expected })
        expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, user, :delete_share, { data: data_expected })
      end
    end
  end
end
