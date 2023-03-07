require 'rails_helper'

describe Reports::Tickets::Sic::InternalStatusPresenter do
  include ActionView::Helpers::NumberHelper

  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::Sic::InternalStatusPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sic::InternalStatusPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sic::InternalStatusPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    context 'rows' do

      before do
        create(:ticket, :sic, :with_parent_sic, :in_sectoral_attendance)

        reopened = create(:ticket, :with_parent_sic, :with_reopen_and_log, reopened_count: 2)

        reopened = create(:ticket, :with_parent_sic, :with_reopen_and_log)
        reopened.final_answer!

        #  4 finalizados
        #  2 Setorial

      end

      let(:scope_hash) do
        {
          'final_answer' => 4,
          'sectoral_attendance' => 2
        }
      end
      let(:scope_total) { 6 }

      let(:internal_statuses) { Ticket.internal_statuses.except(:appeal, :cge_validation).keys }

      let(:expected) do
        internal_statuses.map do |internal_status|
          count = scope_hash[internal_status] || 0
          [
            I18n.t("ticket.internal_statuses.#{internal_status}"),
            count,
            number_to_percentage(count * 100.0 / scope_total, precision: 2)
          ]
        end
      end

      let(:expected_total) do
        [ I18n.t("services.reports.tickets.sic.internal_status.total"), scope_total ]
      end

      it { expect(presenter.rows).to match_array(expected) }
      it { expect(presenter.total_row).to match_array(expected_total) }

    end
  end
end
