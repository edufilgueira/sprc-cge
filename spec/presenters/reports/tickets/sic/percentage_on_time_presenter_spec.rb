require 'rails_helper'

describe Reports::Tickets::Sic::PercentageOnTimePresenter do
  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope.without_other_organs }

  subject(:presenter) { Reports::Tickets::Sic::PercentageOnTimePresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sic::PercentageOnTimePresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sic::PercentageOnTimePresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do

    before do
      create(:attendance, :sic_forward)

      attendance = create(:attendance, :sic_forward)
      attendance.ticket.final_answer!
      create(:ticket, :with_parent_sic, :replied, parent: attendance.ticket)

      attendance = create(:attendance, :sic_forward)
      ticket = attendance.ticket
      ticket.final_answer!
      child = create(:ticket, :with_parent_sic, :replied, parent: ticket)
      child.update_attribute(:deadline, -2)
      child.answers.first.update(sectoral_deadline: -2)

      attendance = create(:attendance, :sic_completed)
      ticket = attendance.ticket
      ticket.final_answer!
      create(:ticket, :with_parent_sic, :replied, parent: ticket)


      create(:ticket, :sic, :with_parent_sic, :replied)
      ticket = create(:ticket, :sic, :with_parent_sic, :replied, deadline: -2)
      ticket.answers.first.update(sectoral_deadline: -2)

      create(:ticket, :sic, :with_parent_sic)
    end

    it 'call_center_on_time_str' do
      expect(presenter.call_center_on_time_str).to eq(I18n.t("services.reports.tickets.sic.percentage_on_time.rows.call_center_on_time"))
    end

    it 'csai_on_time_str' do
      expect(presenter.csai_on_time_str).to eq(I18n.t("services.reports.tickets.sic.percentage_on_time.rows.csai_on_time"))
    end

    it 'all_on_time_str' do
      expect(presenter.all_on_time_str).to eq(I18n.t("services.reports.tickets.sic.percentage_on_time.rows.all_on_time"))
    end

    it 'total_count_str' do
      expect(presenter.total_count_str).to eq(I18n.t("services.reports.tickets.sic.percentage_on_time.rows.total_count"))
    end

    it 'total_completed_count_str' do
      expect(presenter.total_completed_count_str).to eq(I18n.t("services.reports.tickets.sic.percentage_on_time.rows.total_completed_count"))
    end

    it 'total_count' do
      expect(presenter.total_count).to eq(7)
    end

    it 'total_completed_count' do
      expect(presenter.total_completed_count).to eq(5)
    end

    it 'call_center_on_time' do
      expect(presenter.call_center_on_time).to eq('20,00%')
    end

    it 'all_on_time' do
      expect(presenter.all_on_time).to eq('60,00%')
    end

    it 'csai_on_time' do
      expect(presenter.csai_on_time).to eq('40,00%')
    end

  end
end
