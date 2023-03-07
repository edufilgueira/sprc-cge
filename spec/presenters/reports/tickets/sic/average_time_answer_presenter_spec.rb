require 'rails_helper'

describe Reports::Tickets::Sic::AverageTimeAnswerPresenter do
  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::Sic::AverageTimeAnswerPresenter.new(scope) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sic::AverageTimeAnswerPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sic::AverageTimeAnswerPresenter).to have_received(:new).with(scope)
    end
  end

  describe 'helpers' do
    before do
      create(:ticket, :confirmed)
      create(:ticket, :sic, :confirmed, :in_sectoral_attendance)
      create(:ticket, :sic, :replied)

      create(:attendance, :with_ticket_sic) do |attendance|
        ticket = attendance.ticket
        ticket.update(confirmed_at: 3.days.ago)
      end

      create(:classification, :sic, :other_organs).ticket
    end



    # Tempo médio de resposta (:responded_at - :confirmed_at) / total
    context 'average_time_answer' do

      let(:average) do
        scope = responded_scope.where.not(responded_at: nil)
        return 0 if scope.blank?

        total_days = scope.sum { |t| (t.responded_at.to_date - t.confirmed_at.to_date).to_i }
        total_days / scope.count
      end

      context 'call_center_and_csai' do
        let(:responded_scope) { scope.where(tickets_tickets: { id: nil }) }

        it { expect(presenter.average_time(:call_center_and_csai)).to eq(average) }
      end

      context 'csai' do
        let(:responded_scope) do
          scope.left_joins(:attendance).
            where("attendances.id IS NULL or attendances.service_type = :service_type AND " +
                "tickets.internal_status = :status OR tickets_tickets.internal_status = :status",
              service_type: Attendance.service_types[:sic_forward],
              status: Ticket.internal_statuses[:final_answer])
        end

        it { expect(presenter.average_time(:csai)).to eq(average) }
      end

      context 'call_center' do
        let(:responded_scope) do
          scope.joins(:attendance)
            .where(attendances: { service_type: :sic_completed })
            .where("tickets.internal_status = :status OR tickets_tickets.internal_status = :status",
                status: Ticket.internal_statuses[:final_answer])
        end

        it { expect(presenter.average_time(:call_center)).to eq(average) }
      end
    end

    context 'average_time_answer_str' do
      let(:expected) { I18n.t("presenters.reports.tickets.sic.average_time_answer.#{method_name}", count: presenter.average_time_answer(method_name)) }

      after { expect(presenter.average_time_answer_str(method_name)).to eq(expected) }

      context 'call_center_and_csai' do
        let(:method_name) { :call_center_and_csai}
      end

      context 'csai' do
        let(:method_name) { :csai}
      end

      context 'call_center' do
        let(:method_name) { :call_center}
      end
    end
  end
end
