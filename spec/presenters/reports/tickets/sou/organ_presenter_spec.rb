require 'rails_helper'

describe Reports::Tickets::Sou::OrganPresenter do
  let(:date) { Date.today }

  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: true }) }
  let(:scope) { ticket_report.filtered_scope.without_other_organs.without_internal_status(Ticket::INVALIDATED_STATUSES) }

  subject(:presenter) { Reports::Tickets::Sou::OrganPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sou::OrganPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sou::OrganPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    let(:organ) { create(:executive_organ) }
    before do
      create(:ticket, :confirmed, :with_organ)
      create(:ticket, :confirmed, :with_reopen_and_log, reopened_count: 2, organ: organ)
    end

    it { expect(presenter.organ_count(organ)).to eq(3) }
    it { expect(presenter.organ_str(organ)).to eq(organ.title) }
    it { expect(presenter.organ_percentage(3)).to eq('75,00%') }
    it { expect(presenter.total_count).to eq(4) }
  end
end
