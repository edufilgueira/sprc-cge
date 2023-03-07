require 'rails_helper'

describe SetTicketUser do

  let(:document) { '123456' }
  let(:user) { create(:user, document: document) }
  let(:ticket) { create(:ticket, created_by: nil, document: document) }
  let(:service) { SetTicketUser.new(ticket.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(SetTicketUser).to receive(:new).with(ticket.id) { service }
      allow(service).to receive(:call)
      SetTicketUser.call(ticket.id)

      expect(SetTicketUser).to have_received(:new).with(ticket.id)
      expect(service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'new instances' do
      user

      expect(service.ticket).to be_an_instance_of(Ticket)
      expect(service.user).to be_an_instance_of(User)
    end
  end

  describe 'call' do
    it 'set_created_by' do
      ticket
      user
      service.call
      ticket.reload

      expect(ticket.created_by.document).to eq(document)
    end

    it 'do not set_created_by' do
      user
      ticket.document = "d"
      ticket.save

      service.call
      ticket.reload

      expect(ticket.created_by).to eq(nil)
    end
  end

end
