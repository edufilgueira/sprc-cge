require 'rails_helper'

describe Reports::Tickets::UsedInputPresenter do
  let(:date) { Date.today }

  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::UsedInputPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::UsedInputPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::UsedInputPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    before do
      create(:ticket, :confirmed, used_input: :phone)
      create(:ticket, :confirmed, used_input: :phone)
      create(:ticket, :confirmed, :with_reopen_and_log, reopened_count: 2, used_input: :system)
    end

    it { expect(presenter.used_input_count(:phone)).to eq(2) }
    it { expect(presenter.used_input_count(:system)).to eq(3) }
    it { expect(presenter.used_input_percentage(:phone)).to eq('40,00%') }
    it { expect(presenter.used_input_str(:phone)).to eq(Ticket.human_attribute_name("used_input.phone")) }
  end
end
