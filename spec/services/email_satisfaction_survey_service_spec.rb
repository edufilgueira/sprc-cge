require 'rails_helper'

describe EmailSatisfactionSurveyService do
  before { 
    create(:topic, :no_characteristic)
    create(:executive_organ, :dpge)
  }
  let(:ticket) { create(:ticket, :with_parent) }
  let(:other_ticket) { create(:ticket, :with_parent) }
  let(:date_filter) { Date.today - 2.days }
  let(:answer) { create(:answer, :final, ticket: ticket, created_at: date_filter, updated_at: date_filter) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(EmailSatisfactionSurveyService).to receive(:new) { service }
      allow(service).to receive(:call)

      EmailSatisfactionSurveyService.call

      expect(EmailSatisfactionSurveyService).to have_received(:new)
      expect(service).to have_received(:call)
    end
  end

  it 'call notifier' do
    ticket
    answer
    other_ticket
    service = double

    allow(Notifier::SatisfactionSurvey).to receive(:delay) { service }
    allow(service).to receive(:call).once

    EmailSatisfactionSurveyService.call

    expect(Notifier::SatisfactionSurvey).to have_received(:delay)
    expect(service).to have_received(:call).with(answer.id)
  end
end
