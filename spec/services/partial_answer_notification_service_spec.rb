require 'rails_helper'

describe PartialAnswerNotificationService do
  let(:ticket) { create(:ticket, :with_parent, internal_status: :partial_answer) }
  let(:other_ticket) { create(:ticket, :with_parent) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(PartialAnswerNotificationService).to receive(:new) { service }
      allow(service).to receive(:call)

      PartialAnswerNotificationService.call

      expect(PartialAnswerNotificationService).to have_received(:new)
      expect(service).to have_received(:call)
    end
  end

  it 'call notifier' do
    ticket
    other_ticket
    service = double

    allow(Notifier::PartialAnswer).to receive(:delay) { service }
    allow(service).to receive(:call).once

    PartialAnswerNotificationService.call

    expect(Notifier::PartialAnswer).to have_received(:delay)
    expect(service).to have_received(:call).with(ticket.organ_id)
  end
end
