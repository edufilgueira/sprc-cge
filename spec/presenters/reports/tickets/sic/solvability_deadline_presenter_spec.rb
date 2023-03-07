require 'rails_helper'

describe Reports::Tickets::Sic::SolvabilityDeadlinePresenter do
  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope.without_other_organs }

  subject(:presenter) { Reports::Tickets::Sic::SolvabilityDeadlinePresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sic::SolvabilityDeadlinePresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sic::SolvabilityDeadlinePresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    before do
      organ = create(:executive_organ)

      create(:ticket, :with_parent_sic, organ: organ)
      create(:ticket, :with_parent_sic, :replied, organ: organ)
      ticket = create(:ticket, :with_parent_sic, :replied, organ: organ, responded_at: DateTime.now + 25.days, extended: true)
      ticket.answers.update_all(created_at: DateTime.now + 25.days)

      ticket = create(:ticket, :with_parent_sic, :replied, organ: organ, responded_at: DateTime.now + 25.days)
      ticket.answers.update_all(created_at: DateTime.now + 25.days)

      ticket = create(:ticket, :with_parent_sic, :replied, organ: organ, responded_at: DateTime.now + 35.days)
      ticket.answers.update_all(created_at: DateTime.now + 35.days)



      attendance = create(:attendance, :sic_completed)
      ticket = attendance.ticket
      ticket.final_answer!
      child = create(:ticket, :with_parent_sic, :replied, parent: ticket, organ: organ, reopened: 1)
      create(:ticket_log, :reopened, ticket: child, data: {count: 1})
      create(:answer, :final, ticket: child, version: 1, created_at: DateTime.now + 25.days)

      attendance = create(:attendance, :sic_completed)
      ticket = attendance.ticket
      ticket.final_answer!
      child = create(:ticket, :with_parent_sic, :replied, parent: ticket, organ: organ, responded_at: DateTime.now + 25.days, extended: true)
      child.answers.update_all(created_at: DateTime.now + 25.days)

      attendance = create(:attendance, :sic_completed)
      ticket = attendance.ticket
      ticket.final_answer!
      child = create(:ticket, :with_parent_sic, :replied, parent: ticket, organ: organ, responded_at: DateTime.now + 25.days)
      child.answers.update_all(created_at: DateTime.now + 25.days)

      attendance = create(:attendance, :sic_completed)
      ticket = attendance.ticket
      ticket.final_answer!
      child = create(:ticket, :with_parent_sic, :replied, parent: ticket, organ: organ, responded_at: DateTime.now + 35.days)
      child.answers.update_all(created_at: DateTime.now + 35.days)

    end

    it 'call_center_csai' do
      expected = {
        call_center_csai: [[ExecutiveOrgan.first.acronym, 2, 2, 3, 2]],
        call_center: [[ExecutiveOrgan.first.acronym, 1, 1, 1, 1]],
        csai: [[ExecutiveOrgan.first.acronym, 1, 1, 2, 1]]
      }

      expect(presenter.call).to eq(expected)
    end
  end
end
