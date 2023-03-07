require 'rails_helper'

describe Ticket::Search do

  let(:ticket) { create(:ticket) }
  let(:another_ticket) { create(:ticket) }

  it 'protocol' do
    # precisa do reload pois o protocol é gerado como seq.
    # no banco de dados
    ticket.reload
    another_ticket.reload

    tickets = Ticket.search(ticket.parent_protocol)
    expect(tickets).to eq([ticket])
  end

  describe 'name' do
    let(:ticket) { create(:ticket, name: 'abcdef') }
    let(:another_ticket) { create(:ticket, name: 'ghij') }

    it do
      ticket
      another_ticket

      tickets = Ticket.search('a d f')
      expect(tickets).to eq([ticket])
    end
  end

  describe 'social_name' do
    let(:ticket) { create(:ticket, social_name: 'abcdef') }
    let(:another_ticket) { create(:ticket, social_name: 'ghij') }

    it do
      ticket
      another_ticket

      tickets = Ticket.search('a d f')
      expect(tickets).to eq([ticket])
    end
  end

  describe 'email' do
    let(:ticket) { create(:ticket, email: '123456@example.com') }
    let(:another_ticket) { create(:ticket, email: '7890@example.com') }

    it do
      ticket
      another_ticket

      tickets = Ticket.search('1 4 6 @')
      expect(tickets).to eq([ticket])
    end
  end

  describe 'description' do
    let(:ticket) { create(:ticket, description: 'ticket') }
    let(:another_ticket) { create(:ticket) }

    it do
      ticket
      another_ticket

      tickets = Ticket.search('tick')
      expect(tickets).to eq([ticket])
    end
  end

  describe 'denunciation_description' do
    let(:ticket) { create(:ticket, denunciation_description: 'ticket') }
    let(:another_ticket) { create(:ticket) }

    it do
      ticket
      another_ticket

      tickets = Ticket.search('tick')
      expect(tickets).to eq([ticket])
    end
  end

  describe 'document' do
    let(:ticket) { create(:ticket, document: '40800500') }
    let(:another_ticket) { create(:ticket) }

    it do
      ticket
      another_ticket

      tickets = Ticket.search('500')
      expect(tickets).to eq([ticket])
    end
  end

end
