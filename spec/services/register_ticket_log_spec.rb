require 'rails_helper'

describe RegisterTicketLog do
  let(:user) { create(:user) }
  let(:ticket) { comment.commentable }
  let(:comment) { create(:comment) }
  let(:attributes) { {resource: comment, description: 'abc'} }
  let(:service) { RegisterTicketLog.new }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(RegisterTicketLog).to receive(:new) { service }
      allow(service).to receive(:call).with(1, 2, 3, {})
      RegisterTicketLog.call(1, 2, 3)

      expect(RegisterTicketLog).to have_received(:new)
      expect(service).to have_received(:call).with(1, 2, 3, {})
    end
  end

  describe 'initialization' do
    it 'responds to ticket_log' do
      expect(service.ticket_log).to be_an_instance_of(TicketLog)
    end
  end

  describe 'call' do
    let(:ticket_log) { TicketLog.last }
    before { service.call(ticket, user, :invalidate, attributes: attributes) }

    it { expect(ticket_log.ticket).to eq(ticket) }
    it { expect(ticket_log.responsible).to eq(user) }
    it { expect(ticket_log.resource).to eq(comment) }
    it { expect(ticket_log.action).to eq('invalidate') }
    it { expect(ticket_log.description).to eq('abc') }
  end
end
