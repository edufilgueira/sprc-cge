require 'rails_helper'

describe TicketReport, type: :model do

  subject(:ticket_report) { build(:ticket_report) }

  describe 'filters' do
    context 'date_range' do
      let(:starts_at) { Date.today.last_month.beginning_of_month }
      let(:ends_at) { Date.today.last_month.end_of_month }

      let(:organ) { create(:organ) }

      let(:ticket_type) { :sou }

      let(:filters) do
        {
          ticket_type: ticket_type,
          organ: organ.id,
          confirmed_at: {
            start: starts_at,
            end: ends_at
          }
        }
      end

      let(:ticket_report) { create(:ticket_report, filters: filters) }

      context 'confirmed_at' do
        let!(:ticket_active) { create(:ticket, :with_parent, organ: organ, confirmed_at: Date.today.last_month) }
        let!(:ticket_out_range) { create(:ticket, :with_parent, organ: organ, confirmed_at: 2.month.ago) }
        let!(:ticket_reopened) { create(:ticket, :with_parent, organ: organ, confirmed_at: Date.today.last_month, reopened: 1, reopened_at: Date.today.next_month) }

        it { expect(ticket_report.filtered_scope).to match_array([ticket_active, ticket_reopened]) }
      end

      context 'reopened_at' do
        let!(:ticket_reopened) { create(:ticket, :with_reopen_and_log, organ: organ, confirmed_at: 2.month.ago, reopened: 1, reopened_at: Date.today.last_month) }
        let!(:ticket_reopened_out_range) { create(:ticket, :with_reopen_and_log, organ: organ, confirmed_at: 2.month.ago, reopened: 2, reopened_at: Date.today) }
        let(:reopened) { create(:ticket, :with_reopen_and_log, organ: organ, confirmed_at: 2.month.ago, reopened: 2, reopened_at: Date.today) }

        before do
          ticket_reopened.ticket_logs.reopen.first.update_attribute(:created_at, 1.month.ago)
          reopened.ticket_logs.reopen.first.update_attribute(:created_at, 1.month.ago)
        end

        it { expect(ticket_report.filtered_scope).to match_array([ticket_reopened, reopened]) }
      end
    end
  end
end
