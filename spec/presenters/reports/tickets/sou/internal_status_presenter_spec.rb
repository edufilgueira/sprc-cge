require 'rails_helper'

describe Reports::Tickets::Sou::InternalStatusPresenter do
  include ActionView::Helpers::NumberHelper

  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::Sou::InternalStatusPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sou::InternalStatusPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sou::InternalStatusPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    context 'rows' do

      before do
        # 1 Setorial
        create(:ticket, :with_parent, :in_sectoral_attendance)

        # 3 Finalizados
        # 1 Setorial E Fora do Escopo
        reopened = create(:ticket, :with_parent, :with_reopen_and_log, reopened_count: 3)
        ticket_log = reopened.ticket_logs.reopen.last

        reopened.update_attribute(:reopened_at, Date.today.next_month)
        ticket_log.update_attribute(:created_at, Date.today.next_month)

        # 1 Finalizado
        # 1 Setorial
        create(:ticket, :with_parent, :with_reopen_and_log)

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

      let(:internal_statuses) { Ticket.internal_statuses.except(:appeal).keys }

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
        [ I18n.t("services.reports.tickets.sou.internal_status.total"), scope_total ]
      end

      it { expect(presenter.rows).to match_array(expected) }
      it { expect(presenter.total_row).to match_array(expected_total) }

    end
  end
end
