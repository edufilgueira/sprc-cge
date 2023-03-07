require 'rails_helper'

describe Reports::Tickets::Sou::ReopenedPresenter do

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }
  let(:date_range) { beginning_date..end_date.end_of_day }

  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::Sou::ReopenedPresenter.new(scope) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sou::ReopenedPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sou::ReopenedPresenter).to have_received(:new).with(scope)
    end
  end

  describe 'helpers' do
    context 'rows' do
      let(:ticket_1) { create(:ticket, :with_parent) }
      let(:ticket_2) { create(:ticket, :with_parent) }

      let(:ticket_old) { create(:ticket, :with_parent, confirmed_at: 1.year.ago) }

      let(:scope) { Ticket.leaf_tickets }

      let(:row_1) do
        [
          ticket_1.parent_protocol,
          ticket_1.organ_acronym,
          1
        ]
      end

      let(:row_2) do
        [
          ticket_2.parent_protocol,
          ticket_2.organ_acronym,
          2
        ]
      end

      let(:row_3) do
        [
          ticket_old.parent_protocol,
          ticket_old.organ_acronym,
          1
        ]
      end

      let(:expected) { [row_1, row_2, row_3] }

      before do
        create(:ticket_log, :reopened, ticket: ticket_1)

        create(:ticket_log, :reopened, ticket: ticket_2)
        create(:ticket_log, :reopened, ticket: ticket_2)
        create(:ticket_log, :reopened, ticket: ticket_2, created_at: 1.year.ago)

        create(:ticket_log, :reopened, ticket: ticket_old)
        create(:ticket_log, :reopened, ticket: ticket_old, created_at: 1.year.ago)
      end

      it { expect(presenter.rows(date_range)).to match_array(expected) }
    end
  end
end
